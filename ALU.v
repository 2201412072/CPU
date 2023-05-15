`timescale 1ns / 1ps

module ALU(
  input [31:0] A,
  input [31:0] B,
  input [5:0] ALUCtrl,
  input ALUWork,       //时序触发
  input CLK,
  output reg [31:0] result,
  output reg [31:0] H,//乘除法结果暂存
  output reg [31:0] L,
  output reg ALU_busy,
  output reg ZF,            //判零
  output reg OF,           //判溢出
  output reg SF,          //判正负，0正1负
  output reg AWrong_div,  //除数为0报错
  output reg AWrong      //溢出报错
    );
    //reg [63:0] temp;
    //verilog中提供的*和/都只能作用于无符号
    reg [63:0] mul;      //暂存乘积结果
    reg [31:0] A1,B1,temp1,temp2;  //中间结果暂存
    reg signal;  //符号位
    reg [63:0] help[32:0];//第i位表示高位有i个1，其余全为0
    initial
    begin
        $readmemb("D:/component/project_4/ALU_help.txt",help);
    end
    /*always @(posedge CLK)
    begin
        AWrong=0;
        AWrong_div=0;
    end*/
    
    always @*          //时序逻辑
    begin
        AWrong=0;
        AWrong_div=0;
        if(ALUWork==1'b1)
        begin
            AWrong=0;
            AWrong_div=0;
            ALU_busy=1;
            case(ALUCtrl)
                6'b100000://add加
                begin
                    result=A+B;
                    if(A[31]==B[31]&&result[31]!=A[31]) AWrong=1;
                    else AWrong=0;
                end
                
                6'b100001://addu无符号加
                    result=A+B;//u
                    
                6'b100100://and与
                    result=A&B;
                    
                6'b011010://div符号除
                begin
                    if(B==0) AWrong_div=1;   //除0错
                    else
                      begin
                        signal=A[31]^B[31];
                        if(A[31]==1)//求它对应的正数
                          begin
                            A1=(~A)+1;
                          end
                        else A1=A;
                        if(B[31]==1) 
                          begin
                            B1=(~B)+1;
                          end
                        else B1=B;
               
                        temp1=A1/B1;
                        temp2=A1-temp1*B1;
                        result=temp1;//shang
                        
                        if(signal==1) H=(~temp1)+1;//shang
                        else H=temp1;//shang
                        if(A[31]==1) L=(~temp2)+1;//yushu
                        else L=temp2;
                      end
                end
                
                6'b011011:begin//divu无符号除
                    if(B==0) AWrong_div=1;  //除0错
                    else
                      begin
                        result=A/B;
                        H=A/B;//shang
                        L=A-H*B;//yushu
                      end
                end
                
                6'b011000://mult符号乘
                begin
                    signal=A[31]^B[31];   //结果符号位
                    if(A[31]==1)      //求对应的正数
                        begin
                          A1=(~A)+1;
                        end
                    else A1=A;
                    if(B[31]==1) 
                        begin
                          B1=(~B)+1;
                        end
                    else B1=B;
                    mul=A1*B1;       //将对应的正数相乘
                    if(signal==1)    //如果符号位为负，补码取反
                      begin
                        mul=(~mul)+1;
                        L<=mul[31:0];//低位
                        H<=mul[63:32];//高位
                        result<=mul[63:32];
                      end
                    else
                      begin
                        L<=mul[31:0];
                        H<=mul[63:32];
                        result<=mul[63:32];
                      end
                end
                
                6'b011001://multu无符号乘
                begin
                    mul=A*B;
                    L<=mul[31:0];
                    H<=mul[63:32];
                    result<=mul[63:32];
                end
                
                6'b100111://nor或非
                begin
                    result=~(A|B);
                end
                
                6'b100101://or或
                begin
                    result=A|B;
                end
                
                6'b000000://sll逻辑左移
                begin
                    result=B<<A;  //A为0扩展后的位移量
                end
                
                6'b000100://sllv逻辑可变左移
                begin
                    A1[4:0]<=A[4:0];
                    A1[31:5]<=0;
                    result=B<<A1;
                end
                
                6'b101010://slt小于置一（有符号）
                begin
                    if(A[31]==1 &&B[31]==0) result=1;
                    else if(A[31]==0 &&B[31]==1) result=0;
                    else
                    begin
                        result=(A<B)?1:0;
                    end
                end
                
                6'b101011://sltu小于置一（无符号）
                begin
                    result=(A<B)?1:0;
                end
                
                6'b000011://sra算数右移
                begin
                    //B1[4:0]<=B[4:0];
                    //B1[31:5]<=0;
                    result=B>>A;
                    if(B[31]==1'b1)
                        result=result|help[A];
                    //else 
                    //result[31:31-B1+1]=A[31];
                end
                
                6'b000111://srav算数可变右移
                begin
                    A1[4:0]<=A[4:0];
                    A1[31:5]<=0;
                    result=B>>A1;
                    if(B[31]==1'b1)
                        result=result|help[B1];
                    //result[31:31-B1+1]=A[31];
                end
                
                6'b000010://srl逻辑右移
                begin
                    //B1[4:0]<=B[4:0];
                    //B1[31:5]<=0;
                    result=B>>A;
                end
                
                6'b000110://srlv逻辑可变右移
                begin
                    A1[4:0]<=A[4:0];
                    A1[31:5]<=0;
                    result=B>>A1;
                end
                
                6'b100010://sub减
                begin
                    result=A-B;
                    if(A[31]!=B[31]&&B[31]==result[31]) AWrong=1;
                    else AWrong=0;
                end
                
                6'b100011://subu无符号减
                begin
                    result=A-B;
                end
                
                6'b100110://xor异或
                begin
                    result=A^B;
                end
                
             endcase
            ALU_busy=0;
            SF=result[31];     //符号标志位
            ZF=result==0?1:0;  //零标志位
            OF=AWrong==1?1:0;  //溢出标志位
            //if(AWrong==1'b1) #100 AWrong=0;
            //if(AWrong_div==1'b1) #100 AWrong_div=0;
        end
    end
endmodule
