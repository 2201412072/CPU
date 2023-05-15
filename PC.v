`timescale 1ns / 1ps

module PC(
  input PCWr,
  //input PCWrCond,
  //input F3_result,
  input CLK,
  input [31:0] PC_D,
  output reg [31:0] PC_Q
    );
  //reg PC_W;
  initial PC_Q <= 0;
  always @ (posedge CLK) begin
        //PC_W=PCWr|(PCWrCond & F3_result);
        if(PCWr==1) PC_Q=PC_D;
  end
endmodule
