`timescale 1ns / 1ps

module Memory(
    input [31:0] Addr,
    input MemWr,
    input MemRd,
    input [1:0] Type,
    input [31:0] W_data,
    input CLK,
    output reg [31:0] R_data,
    output reg Mem_busy,
    output reg [1:0] MemWrong
    );
    reg [7:0] RAM [0:500];
  
    initial begin
        $readmemb("D:/component/CPUproject/test_Mem.txt",RAM);
        
        RAM[384]=8'b01000010;
        RAM[385]=8'b00000000;
        RAM[396]=8'b00000000;
        RAM[397]=8'b00011000;
        //以上是eret，为了异常处理
    end   

//assign Instdata=ROM[IAddr]; //测试用
    /*
    assign Inst[31:24]=RAM[Addr+0];
    assign Inst[23:16]=RAM[Addr+1];
    assign Inst[15:8]=RAM[Addr+2];
    assign Inst[7:0]=RAM[Addr+3];
    */
    //assign MemWrong=(Type[1]==1'b1)? ((Addr[1:0]==2'b00)? 2'b00 : 2'b01):((Type[0]==1'b0)? 2'b00:((Addr[0]==1'b1)? 2'b01:2'b00));
    /*always @(posedge CLK)
    begin
        MemWrong=2'b00;
    end*/
    always @*
    begin
        MemWrong=2'b00;//由于*有CLK，所以在CLK变的时候就能把它清零了，不至于一直不清零
    if(MemWr==1'b1)
    begin
        Mem_busy=1;
        case(Type)//检查Addr是否输入错误
              2'b00:MemWrong=2'b00;    //字节
              2'b01:begin          //半字
                if(Addr[0]==1) 
                begin
                    MemWrong=2'b01;
                end
                else MemWrong=2'b00;
              end
              2'b10:begin          //字
                if(Addr[1:0]==2'b00) MemWrong=2'b00;
                else MemWrong=2'b10;
              end
              default: $display("wrong");
         endcase
        case(Type)
        2'b00: RAM[Addr]=W_data[7:0];
        2'b01://RAM[Addr][15:0]=W_data[15:0];
        begin
            RAM[Addr]<=W_data[15:8];
            RAM[Addr+1]<=W_data[7:0];
        end
        2'b10://RAM[Addr][31:0]=W_data[31:0];
        begin
            RAM[Addr]<=W_data[31:24];
            RAM[Addr+1]<=W_data[23:16];
            RAM[Addr+2]<=W_data[15:8];
            RAM[Addr+3]<=W_data[7:0];
        end
        default: $display("wrong");
        endcase
        Mem_busy=0;
    end
    if(MemRd==1'b1)
        begin
            //R_data=RAM[Addr];
            Mem_busy=1;
            case(Type)//检查Addr是否输入错误
              2'b00:MemWrong=2'b00;    //字节
              2'b01:begin          //半字
                if(Addr[0]==1) 
                begin
                    MemWrong=2'b01;
                end
                else MemWrong=2'b00;
              end
              2'b10:begin          //字
                if(Addr[1:0]==2'b00) MemWrong=2'b00;
                else MemWrong=2'b10;
              end
              default: $display("wrong");
         endcase
            R_data[31:24]<=RAM[Addr+0];
            R_data[23:16]<=RAM[Addr+1];
            R_data[15:8]<=RAM[Addr+2];
            R_data[7:0]<=RAM[Addr+3];
            Mem_busy=0;
        end
    end
endmodule
