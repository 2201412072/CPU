`timescale 1ns / 1ps

module ZeroExt5to32(
  input [31:0] Inst,
  output [31:0] s
    );
  assign s[4:0]=Inst[10:6];
  assign s[31:5]=0;
endmodule
