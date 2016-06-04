`default_nettype none
`include "INPUT_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_reg_operator(
   input Reset,
   input [`CS_N:0] state,
   output reg [`CO_N-1:0] operator_D,
   output reg operator_EN,
   // io
   input [`IC_N-1:0] in_cmd,
   // register
   input [`IC_N-1:0] command_Q,
   input [`CO_N-1:0] operator_Q,
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
            operator_D <= `CO_AD;
            operator_EN <= 1'b0;
         end
      else if (state == `CS_PARSE)
         case (command_Q)
            `IC_OPAD:
               begin
                  operator_D <= `CO_AD;
                  operator_EN <= 1'b1;
               end
            `IC_OPSB:
               begin
                  operator_D <= `CO_SB;
                  operator_EN <= 1'b1;
               end
            `IC_OPMU:
               begin
                  operator_D <= `CO_MU;
                  operator_EN <= 1'b1;
               end
            `IC_OPDI:
               begin
                  operator_D <= `CO_DI;
                  operator_EN <= 1'b1;
               end
            `IC_EXLP:
               begin
                  operator_D <= `CO_LP;
                  operator_EN <= 1'b1;
               end
            `IC_EXRP:
               begin
                  operator_D <= `CO_RP;
                  operator_EN <= 1'b1;
               end
            default:
               begin
                  operator_D <= `CO_AD;
                  operator_EN <= 1'b0;
               end
         endcase
      else
         begin
            operator_D <= `CO_AD;
            operator_EN <= 1'b0;
         end
   
endmodule
