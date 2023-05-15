`timescale 1ns / 1ps

module TopCPU(
  input clk,
  output [31:0] PC_D, PC_Q,
  output [31:0] Inst
    );

//控制信号
wire PCWr,IRWr,GPRWr,ALUWork,ALUOutWr,LOSrc,HISrc,LOWr,HIWr,CP0Wr,MemRd,MemWr,IntCause,CPUInt,IorD,PColdWr;
wire [1:0] GPRDst, ALUSrcA, Type;
wire [2:0] PCSrc,ALUSrcB,MemtoReg,MDRSrc;
wire [3:0] ALUOP;

//数据通路
wire [31:0] MemAddr,RegA_Q,RegB_Q,MemR_data,GPRW_data,GPR_data1,GPR_data2,ALU_A,ALU_B,ALU_Result,ALU_H,ALU_L,ALUOut_Q,MDR_D,MDR_Q;
wire [31:0] LO_D, HI_D, LO_Q, HI_Q, CP0_Rdata, ZE5to32_Q, SE16to32_Q, SHL2b_Q, ZE16to32_Q, SHL2a_Q, EPC_Q, Cause_D, Cause_Q, F3_Result;
wire [31:0] f1_data;
wire [5:0] ALUCtrl;
wire [4:0] GPRW_Reg;
wire [1:0] MemWrong;
wire Membusy,ALU_busy,ZF,OF,SF,AWrong_div,AWrong;
wire [31:0] PC_old_Q;
reg [31:0] begin_pcd; 
    initial
    begin 
        begin_pcd=0;
    end

//关键部件
CU cu(.CLK(clk),.Inst(Inst),.M_busy(Membusy),.ALU_busy(ALU_busy),.F3_result(F3_Result),.M_Wrong(MemWrong),
.Awrong(AWrong),.PCSrc(PCSrc),.Intcause(IntCause),.CPUInt(CPUInt),.PCWr(PCWr),.PColdWr(PColdWr),.IorD(IorD),
.IRWr(IRWr),.MemWr(MemWr),.MemRd(MemRd),.Type(Type),.GPRDst(GPRDst),.MDRSrc(MDRSrc),.MemtoReg(MemtoReg),
.GPRWr(GPRWr),.ALUSrcA(ALUSrcA),.ALUSrcB(ALUSrcB),.ALU_work(ALUWork),.ALUOUTw(ALUOUTwr),.ALUOP(ALUOP),
.HISrc(HISrc),.LOSrc(LOSrc),.HIWr(HIWr),.LOWr(LOWr),.CP0Wr(CP0Wr) );

PC_old PC_old(.PColdWr(PColdWr),.CLK(clk),.PC_old_D(PC_D),.PC_old_Q(PC_old_Q) );
PC PC(.PCWr(PCWr), .CLK(clk), .PC_D(begin_pcd), .PC_Q(PC_Q) );

//PC_old PC_old(.PColdWr(PColdWr),.CLK(clk),.PC_old_D(PC_old_D),.PC_old_Q(PC_old_Q) );

mux1 mux1(.IorD(IorD), .PC_Q(PC_Q), .ALUOut_Q(ALUOut_Q), .Addr(MemAddr) );

Memory Memory(.Addr(MemAddr), .MemWr(MemWr), .MemRd(MemRd), .Type(Type), .W_data(RegB_Q), .R_data(MemR_data), .Mem_busy(Membusy),
  .MemWrong(MemWrong),.CLK(clk));
  
IR IR(.CLK(clk), .Mem_R_data(MemR_data), .IRwr(IRWr), .Inst(Inst) );

GPR GPR(.CLK(clk), .GPRWr(GPRWr), .W_data(GPRW_data), .R_Reg1(Inst[25:21]), .R_Reg2(Inst[20:16]), .W_Reg(GPRW_Reg),
  .R_data1(GPR_data1), .R_data2(GPR_data2) );
  
ALU ALU(.A(ALU_A), .B(ALU_B), .ALUCtrl(ALUCtrl), .ALUWork(ALUWork), .result(ALU_Result), .H(ALU_H), .L(ALU_L), .ALU_busy(ALU_busy),
  .ZF(ZF), .OF(OF), .SF(SF), .AWrong_div(AWrong_div), .AWrong(AWrong) ,.CLK(clk));

ALU_CU ALU_CU(.Func(Inst[5:0]), .ALUOP(ALUOP), .ALUCtrl(ALUCtrl) );

ALUOut ALUOut(.CLK(clk), .D(ALU_Result), .Q(ALUOut_Q) );

CP0 CP0(.CLK(clk), .CP0Wr(CP0Wr), .R_Reg(Inst[15:11]), .W_Reg(GPRW_Reg), .W_data(RegB_Q), .R_data(CP0_Rdata) );


F3 F3(.Inst31_26(Inst[31:26]), .Inst20_16(Inst[20:16]), .SF(SF), .ZF(ZF), .F3_result(F3_Result) );

HI HI(.CLK(clk), .HIWr(HIWr), .HI_D(HI_D), .HI_Q(HI_Q) );

LO LO(.CLK(clk), .LOWr(LOWr), .LO_D(LO_D), .LO_Q(LO_Q) );
/*原代码
F1 F1(.data(MemR_data), .Mux_f1(MDRSrc), .f1_data(MDR_D) );

MDR MDR(.CLK(clk), .D(MDR_D), .Q(MDR_Q) );

mux2 mux2(.MemtoReg(MemtoReg), .ALUOut_Q(ALUOut_Q), .MDR_Q(MDR_Q), .LO_Q(LO_Q), .HI_Q(HI_Q), .CP0_R_data(CP0_Rdata), .Inst(Inst),
  .GPR_W_data(GPRW_data));
*/
MDR MDR(.CLK(clk), .D(MemR_data), .Q(MDR_Q) );

F1 F1(.data(MDR_Q), .Mux_f1(MDRSrc), .f1_data(f1_data) );

mux2 mux2(.MemtoReg(MemtoReg), .ALUOut_Q(ALUOut_Q), .MDR_Q(f1_data), .LO_Q(LO_Q), .HI_Q(HI_Q), .CP0_R_data(CP0_Rdata), .Inst(Inst),
  .GPR_W_data(GPRW_data));

RegA RegA(.CLK(clk), .D(GPR_data1), .Q(RegA_Q) );

RegB RegB(.CLK(clk), .D(GPR_data2), .Q(RegB_Q) );

SHL2a SHL2a(.Inst(Inst), .Q(SHL2a_Q) );

SHL2b SHL2b(.lsAddr(SE16to32_Q), .outAddr(SHL2b_Q) );

SigExt16to32 SigExt16to32(.Inst(Inst), .lsAddr(SE16to32_Q) );

ZeroExt16to32 ZeroExt16to32(.Inst(Inst), .outAddr(ZE16to32_Q) );

ZeroExt5to32 ZeroExt5to32(.Inst(Inst), .s(ZE5to32_Q) );


 

mux3 mux3(.GPRDst(GPRDst), .Inst(Inst), .W_Reg(GPRW_Reg) );

mux4 mux4(.ALUSrcA(ALUSrcA), .PC_Q(PC_Q), .RegA_Q(RegA_Q), .s(ZE5to32_Q), .ALU_A(ALU_A) );

mux5 mux5(.ALUSrcB(ALUSrcB), .RegB_Q(RegB_Q), .lsAddr(SE16to32_Q), .beqAddr(SHL2b_Q), .zeroExt_out(ZE16to32_Q), .ALU_B(ALU_B) ); 

mux6 mux6(.HISrc(HISrc), .ALU_H(ALU_H), .GPR_R_data1(GPR_data1), .HI_D(HI_D) );

mux7 mux7(.LOSrc(LOSrc), .ALU_L(ALU_L), .GPR_R_data1(GPR_data1), .LO_D(LO_D) );

mux8 mux8(.PCSrc(PCSrc), .ALU_result(ALU_Result), .ALUOut_Q(ALUOut_Q), .SHL2a_Q(SHL2a_Q), .PC_Q(PC_Q), .GPR_R_data1(GPR_data1),
  .EPC_Q(EPC_Q), .PC_D(PC_D) );
  
mux9 mux9(.IntCause(IntCause), .Cause_D(Cause_D) );

Cause Cause(.Cause_D(Cause_D), .CLK(clk), .CPUInt(CPUInt), .Cause_Q(Cause_Q) );

EPC EPC(.CLK(clk), .EPC_D(PC_old_Q), .CPUInt(CPUInt), .EPC_Q(EPC_Q) );
always @(PC_D)
    begin
        begin_pcd=PC_D;
    end
endmodule