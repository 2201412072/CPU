`timescale 1ns / 1ps

module SHL2a(
  input [31:0] Inst,
  output [27:0] Q
    );
  assign Q[27:2]=Inst[25:0];
  assign Q[1:0]=0;
endmodule
