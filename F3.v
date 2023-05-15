`timescale 1ns / 1ps

module F3(
  input [5:0] Inst31_26,
  input [4:0] Inst20_16,
  input  SF,
  input  ZF,
  output reg  F3_result
    );
  always @*
    begin
    case(Inst31_26)
    6'b000001:
    begin
        if(Inst20_16[0]==1'b1)
        begin
            F3_result=!SF;    //���ڵ���0ʱת��
        end
        else
        begin
            F3_result=SF;   //С��0ʱת��
        end
    end
    6'b000100:
    begin
        F3_result=ZF;   //beq���ʱת��
    end
    6'b000101:
    begin
        F3_result=!ZF;  //bne����ʱת��
    end
    6'b000110:
    begin
        F3_result=SF|ZF; //С�ڵ���0ʱת��
    end
    6'b000111:
    begin
        F3_result=!(SF|ZF); //����0ʱת��
    end
    default: $display("wrong");
    endcase
    end
endmodule
