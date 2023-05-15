`timescale 1ns / 1ps

module ALU_CU(
  input [5:0] Func,
  input [3:0] ALUOP,
  output reg [5:0] ALUCtrl
);
    always @(Func or ALUOP)
    begin
        case(ALUOP) 
        //R-R型运算指令
        4'b0000:ALUCtrl=Func;
        //非R-R型  
        4'b0001:ALUCtrl=6'b100000;  //符号加
        4'b0010:ALUCtrl=6'b100001;  //无符号加
        4'b0011:ALUCtrl=6'b100100;  //与
        4'b0100:ALUCtrl=6'b100101;  //或
        4'b0101:ALUCtrl=6'b100110;  //异或
        4'b0110:ALUCtrl=6'b101010;  //小于置1（有符号）
        4'b0111:ALUCtrl=6'b101011;  //小于置1（无符号）
        4'b1000:ALUCtrl=6'b100010;  //符号减
        default: $display("wrong");
        endcase
    end
endmodule
