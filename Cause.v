`timescale 1ns / 1ps

module Cause(
  input [31:0] Cause_D,
  input CLK,
  input CPUInt,
  output reg [31:0] Cause_Q
    );
  always @ (negedge CLK)
    begin
      if(CPUInt==1) Cause_Q=Cause_D;
    end
endmodule
