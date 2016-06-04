`default_nettype none
`include "INPUT_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller_reg_digit(
   input Reset,
   input [`CS_N:0] state,
   output reg [3:0] digit_D,
   output reg digit_EN,
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
            digit_D <= 4'hf;
            digit_EN <= 1'b0;
         end
      else if (state == `CS_PARSE || state == `CS_X_PARSE)
         case (command_Q)
            `IC_NUM0:
               begin
                  digit_D <= 4'd0;
                  digit_EN <= 1'b1;
               end
            `IC_NUM1:
               begin
                  digit_D <= 4'd1;
                  digit_EN <= 1'b1;
               end
            `IC_NUM2:
               begin
                  digit_D <= 4'd2;
                  digit_EN <= 1'b1;
               end
            `IC_NUM3:
               begin
                  digit_D <= 4'd3;
                  digit_EN <= 1'b1;
               end
            `IC_NUM4:
               begin
                  digit_D <= 4'd4;
                  digit_EN <= 1'b1;
               end
            `IC_NUM5:
               begin
                  digit_D <= 4'd5;
                  digit_EN <= 1'b1;
               end
            `IC_NUM6:
               begin
                  digit_D <= 4'd6;
                  digit_EN <= 1'b1;
               end
            `IC_NUM7:
               begin
                  digit_D <= 4'd7;
                  digit_EN <= 1'b1;
               end
            `IC_NUM8:
               begin
                  digit_D <= 4'd8;
                  digit_EN <= 1'b1;
               end
            `IC_NUM9:
               begin
                  digit_D <= 4'd9;
                  digit_EN <= 1'b1;
               end
            default:
               begin
                  digit_D <= 4'hf;
                  digit_EN <= 1'b0;
               end
         endcase
      else
         begin
            digit_D <= 4'hf;
            digit_EN <= 1'b0;
         end
   
endmodule
