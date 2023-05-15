`timescale 1ns / 1ps

module mux7(
  input LOSrc,
  input [31:0] ALU_L,
  input [31:0] GPR_R_data1,
  output [31:0] LO_D
    );
  assign LO_D=(LOSrc==0)?ALU_L:GPR_R_data1;
endmodule
