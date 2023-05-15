`timescale 1ns / 1ps

module mux4(
  input [1:0] ALUSrcA,
  input [31:0] PC_Q,
  input [31:0] RegA_Q,
  input [31:0] s,
  output reg [31:0] ALU_A
    );
always@*
  begin
  case(ALUSrcA)
  2'b00:ALU_A=PC_Q;
  2'b01:ALU_A=RegA_Q;
  2'b10:ALU_A=s;
  endcase
  end
endmodule
