`timescale 1ns / 1ps
`define oper_type IR[31:27]
`define rdst IR[26:22]
`define rsrc1 IR[21:17]
`define imm_mode IR[16]
`define rsrc2 IR [15:11]
`define isrc IR [15:0]

`define movsgpr       5'b00000
`define mov           5'b00001
`define add           5'b00010
`define sub           5'b00011
`define mul           5'b00100
`define ror           5'b00101
`define rand          5'b00110
`define rxor          5'b00111
`define rxnor         5'b01000
`define rnand         5'b10001
`define rnor          5'b10010
`define rnot          5'b10011

`define storereg      5'b01101
`define storedin      5'b01110
`define senddout      5'b01111
`define sendreg       5'b10001

`define jump          5'b10010
`define jcarry        5'b10011
`define jnocarry      5'b10100
`define jsign         5'b10101
`define jnosign       5'b10110
`define jzero         5'b10111
`define jnozero       5'b11000
`define joverflow     5'b11001
`define jnooverflow   5'b11010

`define halt          5'b11011

module top(
input clk,sys_rst,
input [15:0] din,
output reg [15:0] dout
);

reg [31:0] inst_mem[15:0];//stores 16 elements(depth)
reg [15:0] data_mem[15:0];

reg [31:0] IR;

reg [15:0] GPR[31:0];

reg [15:0] SGPR;

reg [31:0] mul_res;

reg jmp_flag=0;
reg stop=0;
reg sign=0,zero=0,overflow=0,carry=0;
task decode_inst();

begin 
jmp_flag=1'b0;
stop=1'b0; // default values for jump
case(`oper_type)

`movsgpr: begin
    GPR[`rdst]=SGPR;

end
`mov :begin
    if(`imm_mode)
        GPR[`rdst]=`isrc;
    else
        GPR[`rdst]=GPR[`rsrc1];
    
        
end
`add : begin
    if(`imm_mode)
        GPR[`rdst]=GPR[`rsrc1]+`isrc;
    else
        GPR[`rdst]=GPR[`rsrc1]+GPR[`rsrc2];
end
`sub : begin
    if(`imm_mode)
        GPR[`rdst]=GPR[`rsrc1]-`isrc;
    else
        GPR[`rdst]=GPR[`rsrc1]-GPR[`rsrc2];
end
`mul: begin
    if(`imm_mode)
        mul_res=GPR[`rsrc1]*`isrc;
    else
        mul_res=GPR[`rsrc1]*GPR[`rsrc2];
        
        GPR[`rdst] = mul_res[15:0];
        SGPR = mul_res[31:16];
end
`ror : begin
    if(`imm_mode)
        GPR[`rdst]=GPR[`rsrc1]|`isrc;
    else
        GPR[`rdst]=GPR[`rsrc1]|GPR[`rsrc2];
end

`rand : begin
    if(`imm_mode)
        GPR[`rdst]=GPR[`rsrc1]&`isrc;
    else
        GPR[`rdst]=GPR[`rsrc1]&GPR[`rsrc2];
end
`rxor : begin
    if(`imm_mode)
        GPR[`rdst]=GPR[`rsrc1]^`isrc;
    else
        GPR[`rdst]=GPR[`rsrc1]^GPR[`rsrc2];
end
 `rxnor : begin
    if(`imm_mode)
        GPR[`rdst]=GPR[`rsrc1]~^`isrc;
    else
        GPR[`rdst]=GPR[`rsrc1]~^GPR[`rsrc2];
end
`rnand: begin
    if(`imm_mode)
        GPR[`rdst]=~(GPR[`rsrc1]&`isrc);
    else
        GPR[`rdst]=~(GPR[`rsrc1]&GPR[`rsrc2]);
end
`rnor: begin
    if(`imm_mode)
        GPR[`rdst]=~(GPR[`rsrc1]|`isrc);
    else
        GPR[`rdst]=~(GPR[`rsrc1]|GPR[`rsrc2]);
end
`rnot: begin
    if(`imm_mode)
        GPR[`rdst]=~(`isrc);
    else
        GPR[`rdst]=~(GPR[`rsrc1]);
end
`storedin:begin
    data_mem[`isrc]=din;
    end
`storereg:begin
    data_mem[`isrc]=GPR[`rsrc1];
    end
`senddout:begin
    dout=data_mem[`isrc];
    end
`sendreg:begin
    GPR[`rdst]=data_mem[`isrc];  
    end  
`jump:begin
    jmp_flag=1'b1;
end
`jcarry:begin
    if(carry)
    jmp_flag=1'b1;
    else
    jmp_flag=1'b0;
end
`jsign:begin
    if(sign)
    jmp_flag=1'b1;
    else
    jmp_flag=1'b0;
end
`jzero:begin
    if(zero)
    jmp_flag=1'b1;
    else
    jmp_flag=1'b0;
end
endcase
end
endtask

reg [16:0]temp_sum;
task decode_condflag();
begin
if(`oper_type==`mul)
    sign=SGPR[15];
else
    sign=GPR[`rdst][15];
    
    
if(`oper_type==`add)
    begin
        if(`imm_mode)
        begin
            temp_sum=GPR[`rsrc1]+`isrc;
            carry=temp_sum[16];
            end
         else
         begin
            temp_sum=GPR[`rsrc2]+GPR[`rsrc1];
            carry=temp_sum[16];
            end

    end
else
    begin
    carry=1'b0;
    end
    
    
zero=`oper_type==`mul?~((|SGPR[15])|(|GPR[`rdst])):~(|GPR[`rdst]);
if(`oper_type == `add)
     begin
       if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & ~IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & GPR[`rsrc2][15] & ~GPR[`rdst][15]));
     end
  else if(`oper_type == `sub)
    begin
       if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & ~IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & ~GPR[`rdst][15]));
    end 
  else
     begin
     overflow = 1'b0;
     end
 
end
endtask




initial begin
$readmemb("D:\insta_data.mem",inst_mem);
end

reg[2:0] count=0;
integer PC=0;

always@(posedge clk)
begin
    if(sys_rst)
    begin
        count<=0;
        PC <=0;
     end
     else
     begin
     if(count<4)
     begin
     count<=count+1;
     end
     else
     begin
     count<=0;
     PC=PC+1;
     end
     end
     
end

always@(*)
begin
if(sys_rst==1'b1)
IR=0;
else
begin
IR=inst_mem[PC];
decode_inst();
decode_condflag();
end
end



endmodule