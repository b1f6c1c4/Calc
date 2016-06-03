`default_nettype none
`include "INPUT_INTERFACE.v"
`include "OUTPUT_INTERFACE.v"
module CPU(
   input Clock,
   input Reset,
   output in_ack,
   input [`IC_N-1:0] in_cmd,
   output [`OD_N-1:0] out_data,
   output [`OC_N-1:0] out_cmd
   );
   
endmodule
