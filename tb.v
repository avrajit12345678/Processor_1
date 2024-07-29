
 
/* 
module tb;
integer i = 0;
 
top dut();
 
///////////////updating value of all GPR to 2
initial begin
for( i = 0; i < 32; i = i + 1)
begin
dut.GPR[i] = 2;
end
end
 
 
 
initial begin
//////// immediate add op
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 2;
dut.`rsrc1 = 2;///gpr[2] = 2
dut.`rdst  = 0;///gpr[0]
dut.`isrc = 4;
#10;
$display("OP:ADI Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[2], dut.`isrc, dut.GPR[0]);
$display("-----------------------------------------------------------------");
////////////register add op
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 2;
dut.`rsrc1 = 4;
dut.`rsrc2 = 5;
dut.`rdst  = 0;
#10;
$display("OP:ADD Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[4], dut.GPR[5], dut.GPR[0] );
$display("-----------------------------------------------------------------");
 
//////////////////////immediate mov op
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 1;
dut.`rdst = 4;///gpr[4]
dut.`isrc = 55;
#10;
$display("OP:MOVI Rdst:%0d  imm_data:%0d",dut.GPR[4],dut.`isrc  );
$display("-----------------------------------------------------------------");
 
//////////////////register mov
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 1;
dut.`rdst = 4;
dut.`rsrc1 = 7;//gpr[7]
#10;
$display("OP:MOV Rdst:%0d  Rsrc1:%0d",dut.GPR[4],dut.GPR[7] );
$display("-----------------------------------------------------------------");
 
//////////////////////logical and imm
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 6;
dut.`rdst = 4;
dut.`rsrc1 = 7;//gpr[7]
dut.`isrc = 56;
#10;
$display("OP:ANDI Rdst:%8b  Rsrc1:%8b imm_d :%8b",dut.GPR[4],dut.GPR[7],dut.`isrc );
$display("-----------------------------------------------------------------");
 
///////////////////logical or imm
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 7;
dut.`rdst = 4;
dut.`rsrc1 = 7;//gpr[7]
dut.`isrc = 56;
#10;
$display("OP:XORI Rdst:%8b  Rsrc1:%8b imm_d :%8b",dut.GPR[4],dut.GPR[7],dut.`isrc );
$display("-----------------------------------------------------------------");

dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 5;
dut.`rdst = 0;
dut.`rsrc1 = 16;//gpr[7]
dut.`rsrc2 = 6;
#10;
$display("OP:OR Rdst:%8b  Rsrc1:%8b Rsrc2 :%8b",dut.GPR[0],dut.GPR[6],dut.GPR[16]);
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 18;
dut.`rdst = 2;
dut.`rsrc1 = 4;//gpr[7]
dut.`rsrc2 = 6;
#10;
$display("OP:NOR Rdst:%8b  Rsrc1:%8b Rsrc2 :%8b",dut.GPR[2],dut.GPR[4],dut.GPR[6]);
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 19;
dut.`rdst = 1;
dut.`rsrc1 = 6;//gpr[7]
#10;
$display("OP:NOR Rdst:%8b  Rsrc1:%8b ",dut.GPR[1],dut.GPR[6]);
$display("-----------------------------------------------------------------");
dut.IR=0;
dut.GPR[0]=0;
dut.GPR[1]=0;
dut.`imm_mode=0;
dut.`rsrc1=0;
dut.`rsrc2=1;
dut.`oper_type=2;
dut.`rdst=2;
#10
$display("OP:Zero Rsrc1:0%d Rsrc2:0%d Rdst:0%d",dut.GPR[0],dut.GPR[1],dut.GPR[2]);
$display("--------------------");
dut.IR=0;
dut.GPR[0]=0;
dut.GPR[1]=16'h8000;
dut.`imm_mode=0;
dut.`rsrc1=0;
dut.`rsrc2=1;
dut.`oper_type=2;
dut.`rdst=2;
#10
$display("OP:Sign Rsrc1:0%d Rsrc2:0%d Rdst:0%d",dut.GPR[0],dut.GPR[1],dut.GPR[2]);
$display("--------------------");
dut.IR=0;
dut.GPR[0]=16'h8000;
dut.GPR[1]=16'h8002;
dut.`imm_mode=0;
dut.`rsrc1=0;
dut.`rsrc2=1;
dut.`oper_type=2;
dut.`rdst=2;
#10
$display("OP:Carry and Overflow Rsrc1:0%d Rsrc2:0%d Rdst:0%d",dut.GPR[0],dut.GPR[1],dut.GPR[2]);
$display("--------------------");


end
 
endmodule
*/
module tb;
 
 
integer i = 0;
 
reg clk = 0,sys_rst = 0;
reg [15:0] din = 0;
wire [15:0] dout;
 
 
top dut(clk, sys_rst, din, dout);
 
always #5 clk = ~clk;
 
initial begin
sys_rst = 1'b1;
repeat(5) @(posedge clk);
sys_rst = 1'b0;
#800;
$stop;
end
 
endmodule