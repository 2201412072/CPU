`timescale 1ns / 1ps

module EPC(
  input CLK,
  input [31:0] EPC_D,
  input CPUInt,
  output reg [31:0] EPC_Q
    );
  always @ (negedge CLK) 
   begin
    if(CPUInt==1) EPC_Q=EPC_D;
   end
endmodule
