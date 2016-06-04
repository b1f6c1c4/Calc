`default_nettype none
`include "INPUT_INTERFACE.v"
module Input_buffer(
	input Clock,
	input Reset,
   input [`IC_N-1:0] in_cmd,
   input ack,
   output reg [`IC_N-1:0] out_cmd
   );
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         out_cmd <= `IC_NONE;
      else if (ack || in_cmd != `IC_NONE)
         out_cmd <= in_cmd;
   
endmodule
