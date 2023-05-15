`timescale 1ns / 1ps

module SigExt16to32(
  input [31:0] Inst,
  output [31:0] lsAddr
    );
  assign lsAddr[15:0]=Inst[15:0];
  assign lsAddr[31:16]=(Inst[15]==1)?16'hffff:16'h0;
endmodule
