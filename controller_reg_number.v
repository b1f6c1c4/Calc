`default_nettype none
`include "INPUT_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_reg_number(
   input Reset,
   input [`CS_N:0] state,
   output reg [`CD_N-1:0] number_D,
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
         number_D <= `CD_0;
      else
         case (state)
            `CS_BACK_CALC, `CS_APP_CALC_1, `CS_APP_CALC_2, `CS_EVALUATE_DD, `CS_EVALUATE_SAVE:
               number_D <= al_C;
            `CS_EVALUATE_D:
               number_D <= dt_data;
            default:
               number_D <= `CD_0;
         endcase
   
endmodule
