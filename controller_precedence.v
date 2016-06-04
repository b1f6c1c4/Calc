`default_nettype none
`include "INPUT_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_precedence(
   input Reset,
   input [`CS_N:0] state,
   output reg [`CO_N-1:0] pr_A,
   output reg [`CO_N-1:0] pr_B,
   // io
   input [`IC_N-1:0] in_cmd,
   // register
   input [`IC_N-1:0] command_Q,
   input [`CO_N-1:0] operator_Q,
   input [`CO_N-1:0] operator_x_Q,
   input [`CD_N-1:0] number_Q,
   input [3:0] digit_Q,
   // memory
   input [`CD_N-1:0] dt_data,
   input dt_empty,
   input [`CO_N-1:0] op_data,
   input op_empty,
   // alu
   input [`CD_N-1:0] al_C,
   // precedence rom
   input pr_res
   );
   
   always @(*)
      if (~Reset)
         begin
            pr_A <= `CO_AD;
            pr_B <= `CO_AD;
         end
      else
         case (state)
            default:
               begin
                  pr_A <= `CO_AD;
                  pr_B <= `CO_AD;
               end
         endcase
   
endmodule
