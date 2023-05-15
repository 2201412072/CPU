`timescale 1ns / 1ps

module test_CPU;
    reg clk;
    wire [31:0] PC_D,PC_Q,Inst;
    TopCPU sim_cpu(.clk(clk),.PC_D(PC_D),.PC_Q(PC_Q),.Inst(Inst));
    
    always #50 clk= ~clk;
    
    initial begin
      clk=0;
      //#3000;
      //#4600; $stop;
     end
endmodule
