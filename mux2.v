`timescale 1ns / 1ps

module mux2(
  input [2:0] MemtoReg,
  input [31:0] ALUOut_Q,
  input [31:0] MDR_Q,
  input [31:0] LO_Q,
  input [31:0] HI_Q,
  input [31:0] CP0_R_data,
  input [31:0] Inst,
  output reg [31:0] GPR_W_data
    );
  reg [31:0] lui;
  always@* 
  begin
  lui[31:16]=Inst[15:0];
  lui[15:0]=0;
  case(MemtoReg)
    3'b000: GPR_W_data=ALUOut_Q;
    3'b001:GPR_W_data=MDR_Q;
    3'b010:GPR_W_data=lui;
    3'b011:GPR_W_data=LO_Q;
    3'b100:GPR_W_data=HI_Q;
    3'b101:GPR_W_data=CP0_R_data;
  endcase
  end
endmodule
