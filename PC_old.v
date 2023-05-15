`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/10 18:34:19
// Design Name: 
// Module Name: PC_old
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC_old(
input PColdWr,
input CLK,
 input [31:0] PC_old_D,
  output reg [31:0] PC_old_Q
    );
    initial PC_old_Q <= 0;
  always @ (posedge CLK) begin
        //PC_W=PCWr|(PCWrCond & F3_result);
        if(PColdWr==1) PC_old_Q=PC_old_D;
  end
endmodule
