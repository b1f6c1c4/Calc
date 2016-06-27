`default_nettype none
module key_scan(
   input CLK,
   input RESET,
   input V1, V2, V3, V4,
   output H1, H2, H3, H4,
   output [7:0] SRCH,
   output [7:0] SRCL,
   output [7:0] DSTH,
   output [7:0] DSTL,
   output [IC_N-1:0] ALU_OP,
   output finish
   );
`include "INPUT_INTERNAL.v"
`include "INPUT_INTERFACE.v"
   
   wire Clock = CLK;
   wire Reset = RESET;
   
   wire [15:0] key;
   wire [IC_N-1:0] cmd_t;
   
   Input_keyboard keybd(.Clock(Clock), .Reset(Reset),
                        .H(H), .V(V), .res(key));
   
   Input_encoder enc(.Clock(Clock), .Reset(Reset),
                     .key(key), .cmd(cmd_t));
   
endmodule
