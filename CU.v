`timescale 1ns / 1ps

module CU(
  input CLK,
  input [31:0] Inst,
  input M_busy,
  input ALU_busy,
  input F3_result,
  input [1:0] M_Wrong, //内存Type报错信号
  input Awrong,      //alu报错信号

  output [2:0] PCSrc,
  output Intcause,
  output reg CPUInt,
  output PCWr,
  output PColdWr,
  output IorD,
  output IRWr,
  output MemWr,
  output MemRd,
  output [1:0] Type,
  output [1:0] GPRDst,
  output [2:0] MDRSrc,
  output [2:0] MemtoReg,
  output GPRWr,
  output [1:0] ALUSrcA,
  output [2:0] ALUSrcB,
  output ALU_work,
  output ALUOUTw,
  output [3:0] ALUOP,
  output HISrc,
  output LOSrc,
  output HIWr,
  output LOWr,
  output CP0Wr
    );
//共48个状态
    reg [5:0] state;
    reg [45:0] ROM[63:0];//该ROM中不同状态为下标，则每个状态的输出在对应位置上，具体状态标号见图
    reg [5:0] ROM1[31:0];//存状态3转移过去的其他状态，加载和保存等指令前6位实际存储同一值
    reg [5:0] ROM2[63:0];//储存Inst前6位为000000对应的状态
    reg [5:0] ROM3[15:0];//存储状态4后应该转移的状态
    reg [5:0] ROM4[4:0];//存储Inst前6位为010000时对应的状态
    reg [5:0] ROM5[5:0];//储存状态5后应转移的状态
    reg [5:0] ROM6[1:0];//储存状态40后应转移的状态
    reg [45:0] uInst;
    reg [1:0] MWrong_reg;//用于记录M_wrong
    reg AWrong_reg;      //alu溢出报错
    
    initial 
    begin
        $readmemb("D:/component/CPUproject/ROM.txt",ROM);
        $readmemb("D:/component/CPUproject/ROM3.txt",ROM3);
        $readmemb("D:/component/CPUproject/ROM1.txt",ROM1);
        $readmemb("D:/component/CPUproject/ROM4.txt",ROM4);
        $readmemb("D:/component/CPUproject/ROM2.txt",ROM2);
        $readmemb("D:/component/CPUproject/ROM5.txt",ROM5);
        ROM6[0]=6'b101001;
        ROM6[1]=6'b101010;
        state=0;  //初始状态设为0
    end
    
    always @(posedge CLK)     //取指令Fetch
    begin//输出信号
        uInst=ROM[state];    
    end
    assign PCSrc=uInst[45:43];
    assign IntCause=uInst[42];
    assign PCWr=uInst[41];
    assign PColdWr=uInst[40];
    assign IorD=uInst[39];
    assign IRWr=uInst[38];
    assign MemWr=uInst[37];
    assign MemRd=uInst[36];
    assign Type=uInst[35:34];
    assign GPRDst=uInst[33:32];
    assign MDRSrc=uInst[31:29];
    assign MemtoReg=uInst[28:26];
    assign GPRWr=uInst[25];
    assign ALUSrcA=uInst[24:23];
    assign ALUSrcB=uInst[22:20];
    assign ALU_work=uInst[19];
    assign ALUOUTw=uInst[18];
    assign ALUOP=uInst[17:14];
    assign HISrc=uInst[13];
    assign LOSrc=uInst[12];
    assign HIWr=uInst[11];
    assign LOWr=uInst[10];
    assign CP0Wr=uInst[9];
    
    always @(negedge CLK)
    begin
       // uInst=ROM[state];
       if(M_Wrong!=0)
       begin
            MWrong_reg=M_Wrong;
       end
       if(Awrong==1'b1)
       begin
            AWrong_reg=1'b1;
       end
        
        CPUInt=1'b0;
       
        case(uInst[8:6])//测试字段
            3'b100://表示状态变为!M_busy !ALU_busy
            begin
                state[0]<=!ALU_busy;
                state[1]<=!M_busy;
                //uInst=ROM[state];
            end
            3'b000://表示状态直接为下地址
            begin
                if(!(M_busy | ALU_busy))
                begin
                    state=uInst[5:0];//等于下地址
                    //uInst=ROM[state];
                end
            end
            3'b001://表示状态3的转移，根据Inst来转移
            begin
                if(!(M_busy | ALU_busy))
                begin
                    case(Inst[31:26])
                        6'b000000:
                        begin
                            state=ROM2[Inst[5:0]];
                            //uInst=ROM[state];
                        end
                        6'b010000:
                        begin
                            state=ROM4[Inst[25:23]];
                            //uInst=ROM[state];
                        end
                        
                        default: 
                        begin
                            state=ROM1[{Inst[31],Inst[29:26]}];
                            //uInst=ROM[state];
                        end
                    endcase
                end
            end
            3'b010://表示根据分支判断结果来转移
            begin
                if(F3_result==1'b0) state=0;//F3输出0代表分支判断失败，不转移
                else state=uInst[5:0];
            end
            3'b011://表示状态4转移
            begin
                state=ROM3[{Inst[31],Inst[29],Inst[27:26]}];
            end
            3'b101://表示状态5转移
            begin
                state=ROM5[Inst[28:26]];
            end
            3'b110://表示状态40转移
            begin
                state=ROM6[Inst[1]];
            end
            default: $display("wrong");
       endcase
       if(state==0)//处理异常
       begin
            if(MWrong_reg!=0)
            begin
                state<=6'b101110;//46
                MWrong_reg<=2'b00;
                AWrong_reg<=1'b0;
                CPUInt=1'b1;
            end
            else if(AWrong_reg==1'b1)
            begin
                state<=6'b110000;//48
                AWrong_reg<=1'b0;
                CPUInt=1'b1;
            end
       end
    end
endmodule
