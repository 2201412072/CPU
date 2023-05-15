`timescale 1ns / 1ps

module ALU_CU(
  input [5:0] Func,
  input [3:0] ALUOP,
  output reg [5:0] ALUCtrl
);
    always @(Func or ALUOP)
    begin
        case(ALUOP) 
        //R-R������ָ��
        4'b0000:ALUCtrl=Func;
        //��R-R��  
        4'b0001:ALUCtrl=6'b100000;  //���ż�
        4'b0010:ALUCtrl=6'b100001;  //�޷��ż�
        4'b0011:ALUCtrl=6'b100100;  //��
        4'b0100:ALUCtrl=6'b100101;  //��
        4'b0101:ALUCtrl=6'b100110;  //���
        4'b0110:ALUCtrl=6'b101010;  //С����1���з��ţ�
        4'b0111:ALUCtrl=6'b101011;  //С����1���޷��ţ�
        4'b1000:ALUCtrl=6'b100010;  //���ż�
        default: $display("wrong");
        endcase
    end
endmodule
