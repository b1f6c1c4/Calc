`default_nettype none
`include "INPUT_INTERFACE.v"
`include "OUTPUT_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_io(
   input Reset,
   input [`CS_N:0] state,
   output reg in_ack,
   output reg [`OD_N-1:0] out_data,
   output reg [`OC_N-1:0] out_cmd,
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
   
   // input
   always @(*)
      if (~Reset)
         in_ack <= 1'b0;
      else
         case (state)
            `CS_INPUT, `CS_X_INPUT:
               in_ack <= 1'b1;
            default:
               in_ack <= 1'b0;
         endcase
   
   // output
   always @(*)
      if (~Reset)
         begin
            out_data <= {`OD_N{1'b0}};
            out_cmd <= `OC_NON;
         end
      else
         case (state)
            `CS_BACK_CALC:
               begin
                  out_data <= {`OD_N{1'b0}};
                  out_cmd <= `OC_ACK;
               end
            `CS_SAVE:
               begin
                  out_data <= number_Q;
                  out_cmd <= `OC_NUM;
               end
            default:
               begin
                  out_data <= {`OD_N{1'b0}};
                  out_cmd <= `OC_NON;
               end
         endcase
   
endmodule
