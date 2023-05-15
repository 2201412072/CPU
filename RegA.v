`timescale 1ns / 1ps

module RegA(
  input CLK,
  input [31:0] D,
  output reg [31:0] Q
    );
  always @(negedge CLK) 
    begin
        Q<=D;
    end
endmodule
