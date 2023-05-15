`timescale 1ns / 1ps

module mux9(
  input IntCause,
  output [31:0] Cause_D
    );
  assign Cause_D=(IntCause==0)?32'h00000028:32'h00000030;
endmodule
