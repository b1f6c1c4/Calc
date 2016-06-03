`default_nettype none
`include "INPUT_INTERFACE.v"
`include "OUTPUT_INTERFACE.v"
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
   
   // fundamental modules
   wire Clock, Reset;
   assign Clock = CLK;
   rst_recover rst(Clock, RST, Reset);
   
   // links
   wire in_ack;
   wire [`IC_N-1:0] in_cmd;
   wire [`OD_N-1:0] out_data;
   wire [`OC_N-1:0] out_cmd;
   
   // main modules
   Input in(.Clock(Clock), .Reset(Reset),
            .H(H), .V(V),
            .ack(in_ack), .cmd(in_cmd));
   CPU proc(.Clock(Clock), .Reset(Reset),
            .in_ack(in_ack), .in_cmd(in_cmd),
            .out_data(out_data), .out_cmd(out_cmd));
   Output out(.Clock(Clock), .Reset(Reset),
              .data(out_data), .cmd(out_cmd),
              .SD(SD), .SEG(SEG), .LD(LD), .Buzz(Buzz));
   
endmodule
