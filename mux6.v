`timescale 1ns / 1ps

module mux6(
  input HISrc,
  input [31:0] ALU_H,
  input [31:0] GPR_R_data1,
  output [31:0] HI_D
    );
  assign HI_D=(HISrc==0)?ALU_H:GPR_R_data1;
endmodule
