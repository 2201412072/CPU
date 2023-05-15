`timescale 1ns / 1ps

module ALU(
  input [31:0] A,
  input [31:0] B,
  input [5:0] ALUCtrl,
  input ALUWork,       //ʱ�򴥷�
  input CLK,
  output reg [31:0] result,
  output reg [31:0] H,//�˳�������ݴ�
  output reg [31:0] L,
  output reg ALU_busy,
  output reg ZF,            //����
  output reg OF,           //�����
  output reg SF,          //��������0��1��
  output reg AWrong_div,  //����Ϊ0����
  output reg AWrong      //�������
    );
    //reg [63:0] temp;
    //verilog���ṩ��*��/��ֻ���������޷���
    reg [63:0] mul;      //�ݴ�˻����
    reg [31:0] A1,B1,temp1,temp2;  //�м����ݴ�
    reg signal;  //����λ
    reg [63:0] help[32:0];//��iλ��ʾ��λ��i��1������ȫΪ0
    initial
    begin
        $readmemb("D:/component/project_4/ALU_help.txt",help);
    end
    /*always @(posedge CLK)
    begin
        AWrong=0;
        AWrong_div=0;
    end*/
    
    always @*          //ʱ���߼�
    begin
        AWrong=0;
        AWrong_div=0;
        if(ALUWork==1'b1)
        begin
            AWrong=0;
            AWrong_div=0;
            ALU_busy=1;
            case(ALUCtrl)
                6'b100000://add��
                begin
                    result=A+B;
                    if(A[31]==B[31]&&result[31]!=A[31]) AWrong=1;
                    else AWrong=0;
                end
                
                6'b100001://addu�޷��ż�
                    result=A+B;//u
                    
                6'b100100://and��
                    result=A&B;
                    
                6'b011010://div���ų�
                begin
                    if(B==0) AWrong_div=1;   //��0��
                    else
                      begin
                        signal=A[31]^B[31];
                        if(A[31]==1)//������Ӧ������
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
                
                6'b011011:begin//divu�޷��ų�
                    if(B==0) AWrong_div=1;  //��0��
                    else
                      begin
                        result=A/B;
                        H=A/B;//shang
                        L=A-H*B;//yushu
                      end
                end
                
                6'b011000://mult���ų�
                begin
                    signal=A[31]^B[31];   //�������λ
                    if(A[31]==1)      //���Ӧ������
                        begin
                          A1=(~A)+1;
                        end
                    else A1=A;
                    if(B[31]==1) 
                        begin
                          B1=(~B)+1;
                        end
                    else B1=B;
                    mul=A1*B1;       //����Ӧ���������
                    if(signal==1)    //�������λΪ��������ȡ��
                      begin
                        mul=(~mul)+1;
                        L<=mul[31:0];//��λ
                        H<=mul[63:32];//��λ
                        result<=mul[63:32];
                      end
                    else
                      begin
                        L<=mul[31:0];
                        H<=mul[63:32];
                        result<=mul[63:32];
                      end
                end
                
                6'b011001://multu�޷��ų�
                begin
                    mul=A*B;
                    L<=mul[31:0];
                    H<=mul[63:32];
                    result<=mul[63:32];
                end
                
                6'b100111://nor���
                begin
                    result=~(A|B);
                end
                
                6'b100101://or��
                begin
                    result=A|B;
                end
                
                6'b000000://sll�߼�����
                begin
                    result=B<<A;  //AΪ0��չ���λ����
                end
                
                6'b000100://sllv�߼��ɱ�����
                begin
                    A1[4:0]<=A[4:0];
                    A1[31:5]<=0;
                    result=B<<A1;
                end
                
                6'b101010://sltС����һ���з��ţ�
                begin
                    if(A[31]==1 &&B[31]==0) result=1;
                    else if(A[31]==0 &&B[31]==1) result=0;
                    else
                    begin
                        result=(A<B)?1:0;
                    end
                end
                
                6'b101011://sltuС����һ���޷��ţ�
                begin
                    result=(A<B)?1:0;
                end
                
                6'b000011://sra��������
                begin
                    //B1[4:0]<=B[4:0];
                    //B1[31:5]<=0;
                    result=B>>A;
                    if(B[31]==1'b1)
                        result=result|help[A];
                    //else 
                    //result[31:31-B1+1]=A[31];
                end
                
                6'b000111://srav�����ɱ�����
                begin
                    A1[4:0]<=A[4:0];
                    A1[31:5]<=0;
                    result=B>>A1;
                    if(B[31]==1'b1)
                        result=result|help[B1];
                    //result[31:31-B1+1]=A[31];
                end
                
                6'b000010://srl�߼�����
                begin
                    //B1[4:0]<=B[4:0];
                    //B1[31:5]<=0;
                    result=B>>A;
                end
                
                6'b000110://srlv�߼��ɱ�����
                begin
                    A1[4:0]<=A[4:0];
                    A1[31:5]<=0;
                    result=B>>A1;
                end
                
                6'b100010://sub��
                begin
                    result=A-B;
                    if(A[31]!=B[31]&&B[31]==result[31]) AWrong=1;
                    else AWrong=0;
                end
                
                6'b100011://subu�޷��ż�
                begin
                    result=A-B;
                end
                
                6'b100110://xor���
                begin
                    result=A^B;
                end
                
             endcase
            ALU_busy=0;
            SF=result[31];     //���ű�־λ
            ZF=result==0?1:0;  //���־λ
            OF=AWrong==1?1:0;  //�����־λ
            //if(AWrong==1'b1) #100 AWrong=0;
            //if(AWrong_div==1'b1) #100 AWrong_div=0;
        end
    end
endmodule
