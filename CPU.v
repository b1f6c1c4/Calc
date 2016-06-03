`default_nettype none
`include "INPUT_INTERFACE.v"
`include "OUTPUT_INTERFACE.v"
`include "STACK_INTERFACE.v"
`include "CPU_INTERNAL.v"
module CPU(
   input Clock,
   input Reset,
   output in_ack,
   input [`IC_N-1:0] in_cmd,
   output [`OD_N-1:0] out_data,
   output [`OC_N-1:0] out_cmd
   );
   
   wire [`CD_N-1:0] dt_data;
   wire [`SC_N-1:0] dt_cmd;
   wire [`CO_N-1:0] op_data;
   wire [`SC_N-1:0] op_cmd;
   stack #(`CD_N) dt(.Clock(Clock), .Reset(Reset),
                     .data(dt_data), .cmd(dt_cmd));
   stack #(`CO_N) op(.Clock(Clock), .Reset(Reset),
                     .data(op_data), .cmd(op_cmd));
   
   wire [`CD_N-1:0] al_A, al_B, al_C;
   wire [`AC_N-1:0] al_cmd;
   alu #(`CD_N) al(.A(al_A), .B(al_B),
                   .cmd(al_cmd), .C(al_C));
   
endmodule
