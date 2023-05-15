`timescale 1ns / 1ps

module IR(
    input CLK,
    input [31:0] Mem_R_data,
    input IRwr,
    output reg [31:0] Inst
    );
    always @(negedge CLK)
    begin
        if(IRwr==1) Inst=Mem_R_data;
    end
endmodule
