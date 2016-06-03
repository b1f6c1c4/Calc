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
   
   // fundamental modules
   wire Clock, Reset;
   assign Clock = CLK;
   rst_recover rst(Clock, RST, Reset);
   
endmodule
