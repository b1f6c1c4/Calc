`default_nettype none
`timescale 10ns/1ps
module CPU_tb();
`include "INPUT_INTERFACE.v"
`include "OUTPUT_INTERFACE.v"
`include "STACK_INTERFACE.v"
`include "ALU_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
   
   reg Clock;
   reg Reset;
   wire in_ack;
   reg [IC_N-1:0] in_cmd;
   wire [OD_N-1:0] out_data;
   wire [OC_N-1:0] out_cmd;
   
   CPU mdl(Clock, Reset, in_ack, in_cmd, out_data, out_cmd);
   
   initial
      begin
         Reset = 1'b0;
         #2 Reset = 1'b1;
      end
   
   initial
      begin
         Clock = 1'b1;
         forever
            #2 Clock = ~Clock;
      end
   
   task send_and_ack(input [IC_N-1:0] cmd);
      begin
         #1 in_cmd = cmd;
         @(posedge Clock);
         while (~in_ack)
            @(posedge Clock);
         in_cmd = IC_NONE;
      end
   endtask
   
   initial
      begin
         in_cmd = IC_NONE;
         send_and_ack(IC_EXLP);
         send_and_ack(IC_NUM1);
         send_and_ack(IC_OPAD);
         send_and_ack(IC_NUM2);
         send_and_ack(IC_EXRP);
         send_and_ack(IC_OPMU);
         send_and_ack(IC_OPSB);
         send_and_ack(IC_NUM3);
         send_and_ack(IC_CTOK);
         #(4*35);
         $finish;
      end
   
endmodule
