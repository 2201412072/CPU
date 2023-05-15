`timescale 1ns / 1ps

module HI(
  input CLK,
  input HIWr,
  input [31:0] HI_D,
  output reg [31:0] HI_Q
    );
  always @(negedge CLK) 
    begin
        if(HIWr==1) HI_Q <= HI_D;
    end
endmodule
