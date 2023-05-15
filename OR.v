`timescale 1ns / 1ps

module OR(
  input AWrong_div,
  input AWrong,
  input M_Wrong,
  output Error1
    );
  assign Error1=(AWrong_div|AWrong)|M_Wrong;
endmodule
