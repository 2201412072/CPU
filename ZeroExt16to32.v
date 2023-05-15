`timescale 1ns / 1ps

module ZeroExt16to32(
  input [31:0] Inst,
  output [31:0] outAddr
    );
  assign outAddr[15:0]=Inst[15:0];
  assign outAddr[31:16]=0;
endmodule
