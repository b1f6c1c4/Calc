`default_nettype none
module Calc(
   input CLK,
   input RST,
   input [3:0] H,
   output [3:0] V,
   output [0:3] SD,
   output [0:7] SEG,
   output [7:0] LD,
   output Buzz
   );
`include "INPUT_INTERFACE.v"
`include "OUTPUT_INTERFACE.v"
   
   // fundamental modules
   wire Clock, Reset;
   assign Clock = CLK;
   rst_recover rst(Clock, RST, Reset);
   
   // links
   wire [7:0] SRCH, SRCL, DSTH, DSTL;
   wire [IC_N-1:0] ALU_OP;
   wire finish;
   wire [OD_N-1:0] out_data;
   wire [OC_N-1:0] out_cmd;
   
   // main modules
   key_scan in(.CLK(Clock), .RESET(Reset),
            .V1(H[3]), .V2(H[2]), .V3(H[1]), V4(H[0]),
            .H1(V[3]), .H2(V[2]), .H3(V[1]), H4(V[0]),
            .SRCH(SRCH), .SRCL(SRCL), .DSTH(.DSTH), .DSTL(.DSTL),
            .ALU_OP(ALU_OP), .finish(.finish));
   CPU proc(.Clock(Clock), .Reset(Reset),
            .in_ack(in_ack), .in_cmd(in_cmd),
            .out_data(out_data), .out_cmd(out_cmd));
   Output out(.Clock(Clock), .Reset(Reset),
              .data(out_data), .cmd(out_cmd),
              .SD(SD), .SEG(SEG), .LD(LD), .Buzz(Buzz));
   
endmodule
