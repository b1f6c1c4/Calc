`default_nettype none
`include "INPUT_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_reg_number(
   input Reset,
   input [`CS_N:0] state,
   output reg [`CD_N-1:0] number_D,
   output reg number_EN,
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
            number_D <= `CD_0;
            number_EN <= 1'b0;
         end
      else
         case (state)
            `CS_BACK_D:
               begin
                  number_D <= dt_data;
                  number_EN <= 1'b1;
               end
            `CS_BACK_CALC:
               begin
                  number_D <= al_C;
                  number_EN <= 1'b1;
               end
            default:
               begin
                  number_D <= `CD_0;
                  number_EN <= 1'b0;
               end
         endcase
   
endmodule
