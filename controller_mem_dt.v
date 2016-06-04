`default_nettype none
`include "INPUT_INTERFACE.v"
`include "STACK_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_mem_dt(
   input Reset,
   input [`CS_N:0] state,
   output [`CD_N-1:0] dt_data,
   output reg [`SC_N-1:0] dt_cmd,
   // io
   input [`IC_N-1:0] in_cmd,
   // register
   input [`IC_N-1:0] command_Q,
   input [`CO_N-1:0] operator_Q,
   input [`CO_N-1:0] operator_x_Q,
   input [`CD_N-1:0] number_Q,
   input [3:0] digit_Q,
   // memory
   input dt_empty,
   input [`CO_N-1:0] op_data,
   input op_empty,
   // alu
   input [`CD_N-1:0] al_C,
   // precedence rom
   input pr_res
   );
   
   reg [`CD_N-1:0] dt_data_D;
   assign dt_data = dt_cmd == `SC_PUS ? dt_data_D : {`CD_N{1'bz}};
   
   always @(*)
      if (~Reset)
         begin
            dt_data_D <= `CD_0;
            dt_cmd <= `SC_NON;
         end
      else
         case (state)
            `CS_BACK, `CS_APP, `CS_CLEAR, `CS_EVALUATE, `CS_EVALUATE_D:
               begin
                  dt_data_D <= `CD_0;
                  dt_cmd <= `SC_POP;
               end
            `CS_SAVE, `CS_EVALUATE_SAVE:
               begin
                  dt_data_D <= number_Q;
                  dt_cmd <= `SC_PUS;
               end
            `CS_CRE:
               begin
                  dt_data_D <= digit_Q;
                  dt_cmd <= `SC_PUS;
               end
            `CS_ERROR:
               begin
                  dt_data_D <= `CD_0;
                  dt_cmd <= `SC_CLR;
               end
            default:
               begin
                  dt_data_D <= `CD_0;
                  dt_cmd <= `SC_NON;
               end
         endcase
   
endmodule
