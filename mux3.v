`timescale 1ns / 1ps

module mux3(
  input [1:0] GPRDst,
  input [31:0] Inst,
  output reg [4:0] W_Reg
    );
  always@*
  begin
    case(GPRDst)
      2'b00: W_Reg=Inst[20:16];
      2'b01: W_Reg=Inst[15:11];
      2'b10: W_Reg=31;
    endcase
  end
endmodule
