`default_nettype none
`include "OUTPUT_INTERFACE.v"
module Output(
	input Clock,
	input Reset,
   input [`OD_N-1:0] data,
   input [`OC_N-1:0] cmd,
	output [0:3] SD,
	output [0:7] SEG,
	output [7:0] LD,
	output Buzz
   );
   
endmodule
