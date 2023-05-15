`timescale 1ns / 1ps

module SHL2b(
  input [31:0] lsAddr,
  output [31:0] outAddr
    );
  assign outAddr=lsAddr<<2;
endmodule
