`timescale 1ns / 1ps

module CP0(          //除了EPC和CAUSE之外的寄存器
  input CLK,
  input CP0Wr,
  input [4:0] R_Reg,  
  input [4:0] W_Reg,
  input [31:0] W_data,
  output [31:0] R_data
    );
  reg [31:0] CP0[0:31];
  initial begin
    $readmemb("D:/component/project_4/project_4.srcs/sources_1/new/test_CP0.txt",CP0);
  end
  
  assign R_data=CP0[R_Reg];
  always @(negedge CLK) 
    begin
        if(CP0Wr==1) CP0[W_Reg] = W_data;
    end
endmodule
