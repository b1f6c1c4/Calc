`default_nettype none
`include "INPUT_INTERFACE.v"
module Input(
	input Clock,
	input Reset,
	input [3:0] H,
	output [3:0] V,
   input ack,
   output [`IC_N-1:0] cmd
   );
   
endmodule
