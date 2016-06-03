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
   
   wire [15:0] key;
   
   Input_keyboard keybd(.Clock(Clock), .Reset(Reset),
                        .H(H), .V(V), .res(key));
   
   Input_encoder enc(.Clock(Clock), .Reset(Reset),
                     .key(key), .cmd(cmd));
   
endmodule
