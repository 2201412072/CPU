`timescale 1ns / 1ps

module mux1(
  input IorD,
  input [31:0] PC_Q,
  input [31:0] ALUOut_Q,
  output [31:0] Addr
    );
  assign Addr=(IorD==0)? PC_Q:ALUOut_Q; 
endmodule
