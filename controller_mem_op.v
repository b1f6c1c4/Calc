`default_nettype none
`include "INPUT_INTERFACE.v"
`include "STACK_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_mem_op(
   input Reset,
   input [`CS_N:0] state,
   output [`CO_N-1:0] op_data,
   output reg [`SC_N-1:0] op_cmd,
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
   input op_empty,
   // alu
   input [`CD_N-1:0] al_C,
   // precedence rom
   input pr_res
   );
   
   reg [`CO_N-1:0] op_data_D;
   assign op_data = op_cmd == `SC_PUS ? op_data_D : {`CO_N{1'bz}};
   
   always @(*)
      if (~Reset)
         begin
            op_data_D <= `CO_NO;
            op_cmd <= `SC_NON;
         end
      else
         case (state)
            default:
               begin
                  op_data_D <= `CO_NO;
                  op_cmd <= `SC_NON;
               end
         endcase
   
endmodule
