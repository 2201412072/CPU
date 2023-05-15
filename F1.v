`timescale 1ns / 1ps

module F1(
  input [31:0] data,
  input [2:0] Mux_f1,
  output reg [31:0] f1_data
    );
    always @(data or Mux_f1)
    begin
        case(Mux_f1)
        3'b000:        //×Ö½ÚµÄ·ûºÅÀ©Õ¹
        begin
            f1_data[7:0]<=data[7:0];
            f1_data[31:8]=(data[7]==1)? 24'hffffff:24'h0;
        end
        3'b001:        //×Ö½ÚµÄÁãÀ©Õ¹
        begin
            f1_data[7:0]<=data[7:0];
            f1_data[31:8]<=24'h0;
        end
        3'b010:        //°ë×ÖµÄ·ûºÅÀ©Õ¹
        begin
            f1_data[15:0]<=data[15:0];
            f1_data[31:16]<=(data[15]==1)? 16'hffff:16'h0;
        end
        3'b011:        //°ë×ÖµÄÁãÀ©Õ¹
        begin
            f1_data[15:0]<=data[15:0];
            f1_data[31:16]<=16'h0;
        end
        3'b100:        //×Ö
        begin
            f1_data=data;
        end
        default: $display("wrong");
        endcase
    end
endmodule
