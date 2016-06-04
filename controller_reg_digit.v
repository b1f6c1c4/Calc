`default_nettype none
`include "INPUT_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_reg_digit(
   input Reset,
   input [`CS_N:0] state,
   output reg [3:0] digit_D,
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
         digit_D <= digit_Q;
      else if (state == `CS_INPUT || state == `CS_X_INPUT)
         case (in_cmd)
            `IC_NUM0:
               digit_D <= 4'd0;
            `IC_NUM1:
               digit_D <= 4'd1;
            `IC_NUM2:
               digit_D <= 4'd2;
            `IC_NUM3:
               digit_D <= 4'd3;
            `IC_NUM4:
               digit_D <= 4'd4;
            `IC_NUM5:
               digit_D <= 4'd5;
            `IC_NUM6:
               digit_D <= 4'd6;
            `IC_NUM7:
               digit_D <= 4'd7;
            `IC_NUM8:
               digit_D <= 4'd8;
            `IC_NUM9:
               digit_D <= 4'd9;
            default:
               digit_D <= 4'hf;
         endcase
      else
         digit_D <= digit_Q;
   
endmodule
