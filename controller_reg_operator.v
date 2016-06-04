`default_nettype none
`include "INPUT_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_reg_operator(
   input Reset,
   input [`CS_N:0] state,
   output reg [`CO_N-1:0] operator_D,
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
         operator_D <= operator_Q;
      else if (state == `CS_INPUT || state == `CS_X_INPUT)
         case (in_cmd)
            `IC_OPAD:
               operator_D <= `CO_AD;
            `IC_OPSB:
               operator_D <= `CO_SB;
            `IC_OPMU:
               operator_D <= `CO_MU;
            `IC_OPDI:
               operator_D <= `CO_DI;
            `IC_EXLP:
               operator_D <= `CO_LP;
            `IC_EXRP:
               operator_D <= `CO_RP;
            `IC_CTOK:
               operator_D <= `CO_OK;
            default:
               operator_D <= `CO_NO;
         endcase
      else
         operator_D <= operator_Q;
   
endmodule
