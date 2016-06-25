`default_nettype none
module controller(
   input Clock,
   input Reset,
   // io
   output reg in_ack,
   input [IC_N-1:0] in_cmd,
   output reg [OD_N-1:0] out_data,
   output reg [OC_N-1:0] out_cmd,
   // register command
   output reg [IC_N-1:0] command_D,
   input [IC_N-1:0] command_Q,
   // register operator
   output reg [CO_N-1:0] operator_D,
   input [CO_N-1:0] operator_Q,
   // register operator_x
   output reg [CO_N-1:0] operator_x_D,
   input [CO_N-1:0] operator_x_Q,
   // register number
   output reg [CD_N-1:0] number_D,
   input [CD_N-1:0] number_Q,
   // register digit
   output reg [3:0] digit_D,
   input [3:0] digit_Q,
   // memory dt
   inout [CD_N-1:0] dt_data,
   input dt_empty,
   output reg [SC_N-1:0] dt_cmd,
   // memory op
   inout [CO_N-1:0] op_data,
   input op_empty,
   output reg [SC_N-1:0] op_cmd,
   // alu
   output reg [CD_N-1:0] al_A,
   output reg [CD_N-1:0] al_B,
   input [CD_N-1:0] al_C,
   output reg [AC_N-1:0] al_cmd,
   // precedence rom
   output reg [CO_N-1:0] pr_A,
   output reg [CO_N-1:0] pr_B,
   input pr_res
   );
`include "INPUT_INTERFACE.v"
`include "OUTPUT_INTERFACE.v"
`include "STACK_INTERFACE.v"
`include "ALU_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
   reg [CS_N:0] state;
   
`include "controller_io.v"
`include "controller_reg_command.v"
`include "controller_reg_operator.v"
`include "controller_reg_operator_x.v"
`include "controller_reg_number.v"
`include "controller_reg_digit.v"
`include "controller_mem_dt.v"
`include "controller_mem_op.v"
`include "controller_alu.v"
`include "controller_precedence.v"
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         state <= CS_X_INPUT;
      else
         case (state)
            CS_INPUT:
               case (in_cmd)
                  IC_CLBK: state <= CS_BACK;
                  IC_CLCL: state <= CS_CLEAR;
                  IC_NONE: state <= CS_INPUT;
                  default: state <= CS_PARSE;
               endcase
            CS_X_INPUT:
               case (in_cmd)
                  IC_CLBK: state <= CS_X_INPUT;
                  IC_CLCL: state <= CS_X_INPUT;
                  IC_NONE: state <= CS_X_INPUT;
                  default: state <= CS_X_PARSE;
               endcase
            CS_PARSE:
               case (operator_Q)
                  CO_LP: state <= CS_PUSH_OP;
                  CO_AD, CO_SB, CO_MU, CO_DI, CO_RP, CO_OK:
                     state <= CS_FLUSH;
                  default:
                     if (digit_Q == 4'hf)
                        state <= CS_INPUT; // invalid
                     else
                        state <= CS_APP;
               endcase
            CS_X_PARSE:
               case (operator_Q)
                  CO_LP: state <= CS_PUSH_OP;
                  CO_AD: state <= CS_PUSH_SIGN;
                  CO_SB: state <= CS_PUSH_SIGN;
                  CO_MU: state <= CS_X_INPUT;
                  CO_DI: state <= CS_X_INPUT;
                  CO_RP: state <= CS_X_INPUT;
                  CO_OK: state <= CS_FLUSH;
                  default:
                     if (digit_Q == 4'hf)
                        state <= CS_X_INPUT; // invalid
                     else
                        state <= CS_CRE;
               endcase
            CS_BACK:
               if (dt_empty)
                  state <= CS_INPUT;
               else
                  state <= CS_BACK_CALC;
            CS_BACK_CALC:
               state <= CS_SAVE;
            CS_SAVE:
               state <= CS_INPUT;
            CS_CRE:
               state <= CS_INPUT;
            CS_APP:
               if (dt_empty) // invalid
                  state <= CS_ERROR;
               else
                  state <= CS_APP_CALC_1;
            CS_APP_CALC_1:
               state <= CS_APP_CALC_2;
            CS_APP_CALC_2:
               state <= CS_SAVE;
            CS_CLEAR:
               state <= CS_X_INPUT;
            CS_FLUSH:
               if (~op_empty)
                  state <= CS_COMPARE;
               else if (operator_Q == CO_RP)
                  state <= CS_ERROR;
               else if (operator_Q == CO_OK)
                  state <= CS_INPUT;
               else
                  state <= CS_PUSH_OP;
            CS_COMPARE:
               if (operator_Q == CO_RP && op_data == CO_LP)
                  state <= CS_POP_OP;
               else if (pr_res || operator_Q == CO_RP && op_data != CO_LP)
                  state <= CS_EVALUATE;
               else
                  state <= CS_PUSH_OP;
            CS_EVALUATE:
               if (dt_empty)
                  state <= CS_ERROR;
               else if (operator_x_Q == CO_PS || operator_x_Q == CO_NS)
                  state <= CS_CHG_SIGN;
               else
                  state <= CS_EVALUATE_D;
            CS_EVALUATE_D:
               if (dt_empty)
                  state <= CS_ERROR;
               else
                  state <= CS_EVALUATE_DD;
            CS_EVALUATE_DD:
               state <= CS_EVALUATE_SAVE;
            CS_EVALUATE_SAVE:
               state <= CS_FLUSH;
            CS_CHG_SIGN:
               state <= CS_EVALUATE_SAVE;
            CS_PUSH_OP:
               state <= CS_X_INPUT;
            CS_POP_OP:
               state <= CS_INPUT;
            CS_PUSH_SIGN:
               state <= CS_X_INPUT;
            CS_ERROR:
               state <= CS_X_INPUT;
         endcase
   
endmodule
