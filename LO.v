`timescale 1ns / 1ps

module LO(
  input CLK,
  input LOWr,
  input [31:0] LO_D,
  output reg [31:0] LO_Q
    );
  always @(negedge CLK) 
    begin
        if(LOWr==1) LO_Q <= LO_D;
    end
endmodule
