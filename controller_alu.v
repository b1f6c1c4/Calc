`default_nettype none
`include "INPUT_INTERFACE.v"
`include "ALU_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_alu(
   input Reset,
   input [`CS_N:0] state,
   output reg [`CD_N-1:0] al_A,
   output reg [`CD_N-1:0] al_B,
   output reg [`AC_N-1:0] al_cmd,
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
            al_A <= `CD_0;
            al_B <= `CD_0;
            al_cmd <= `AC_AD;
         end
      else
         case (state)
            `CS_BACK_CALC:
               begin
                  al_A <= number_Q;
                  al_B <= 4'd10;
                  al_cmd <= `AC_RM;
               end
            default:
               begin
                  al_A <= `CD_0;
                  al_B <= `CD_0;
                  al_cmd <= `AC_AD;
               end
         endcase
   
endmodule
