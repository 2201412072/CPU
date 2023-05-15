`timescale 1ns / 1ps

module mux5(
  input [2:0] ALUSrcB,
  input [31:0] RegB_Q,
  input [31:0] lsAddr,
  input [31:0] beqAddr,
  input [31:0] zeroExt_out,
  output reg [31:0] ALU_B
    );
//always@*

    always@*
    begin
      case(ALUSrcB)
      3'b000:ALU_B=RegB_Q;
      3'b001:ALU_B=4;
      3'b010:ALU_B=lsAddr;
      3'b011:ALU_B=beqAddr;
      3'b100:ALU_B=zeroExt_out;
      3'b101:ALU_B=0;
      endcase
    end
endmodule
