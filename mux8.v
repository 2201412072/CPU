`timescale 1ns / 1ps

module mux8(
  input [2:0] PCSrc,
  input [31:0] ALU_result,
  input [31:0] ALUOut_Q,
  input [27:0] SHL2a_Q,
  input [31:0] PC_Q,
  input [31:0] GPR_R_data1,
  input [31:0] EPC_Q,
  output reg [31:0] PC_D
    );
  reg [31:0] tempPC;
  always@*
  begin
  tempPC[31:28]<=PC_Q[31:28];
  tempPC[27:0]<=SHL2a_Q;
  case(PCSrc)
  3'b000:PC_D=ALU_result;
  3'b001:PC_D=ALUOut_Q;
  3'b010:PC_D=tempPC;
  3'b011:PC_D=GPR_R_data1;
  3'b100:PC_D=EPC_Q;
  3'b101:PC_D=32'h00000180;
  endcase
  end
endmodule
