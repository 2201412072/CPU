`timescale 1ns / 1ps

module GPR(
    input CLK,
    input GPRWr,
    input [31:0] W_data,
    input [4:0] R_Reg1,
    input [4:0] R_Reg2,
    input [4:0] W_Reg,
    output [31:0] R_data1,
    output [31:0] R_data2
    );
   
    reg [31:0] GPR[0:31];
    initial begin
        $readmemb("D:/component/CPUproject/test_GPR.txt",GPR);
    end
    
    assign R_data1=GPR[R_Reg1];
    assign R_data2=GPR[R_Reg2];
    
    always @(negedge CLK) 
    begin
        if(GPRWr==1) GPR[W_Reg] <= W_data;
    end
    
endmodule
