`default_nettype none
`include "INPUT_INTERFACE.v"
`include "OUTPUT_INTERFACE.v"
`include "STACK_INTERFACE.v"
`include "CPU_INTERNAL.v"
`include "CONT_INTERNAL.v"
module controller(
   input Clock,
   input Reset,
   // io
   output in_ack,
   input [`IC_N-1:0] in_cmd,
   output [`OD_N-1:0] out_data,
   output [`OC_N-1:0] out_cmd,
   // register command
   output [`IC_N-1:0] command_D,
   output command_EN,
   input [`IC_N-1:0] command_Q,
   // register operator
   output [`CO_N-1:0] operator_D,
   output operator_EN,
   input [`CO_N-1:0] operator_Q,
   // register operator_x
   output [`CO_N-1:0] operator_x_D,
   output operator_x_EN,
   input [`CO_N-1:0] operator_x_Q,
   // register number
   output [`CD_N-1:0] number_D,
   output number_EN,
   input [`CD_N-1:0] number_Q,
   // register digit
   output [3:0] digit_D,
   output digit_EN,
   input [3:0] digit_Q,
   // memory dt
   inout [`CD_N-1:0] dt_data,
   input dt_empty,
   output [`SC_N-1:0] dt_cmd,
   // memory op
   inout [`CO_N-1:0] op_data,
   input op_empty,
   output [`SC_N-1:0] op_cmd,
   // alu
   output [`CD_N-1:0] al_A,
   output [`CD_N-1:0] al_B,
   input [`CD_N-1:0] al_C,
   output [`AC_N-1:0] al_cmd,
   // precedence rom
   output [`CO_N-1:0] pr_A,
   output [`CO_N-1:0] pr_B,
   input pr_res
   );
   
   reg [`CS_N:0] state;
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         state <= `CS_X_INPUT;
      else
         case (state)
            `CS_INPUT:
               case (in_cmd)
                  `IC_CLBK: state <= `CS_BACK;
                  `IC_CLCL: state <= `CS_CLEAR;
                  `IC_NONE: state <= `CS_INPUT;
                  default: state <= `CS_PARSE;
               endcase
            `CS_X_INPUT:
               case (in_cmd)
                  `IC_CLBK: state <= `CS_X_INPUT;
                  `IC_CLCL: state <= `CS_X_INPUT;
                  `IC_NONE: state <= `CS_X_INPUT;
                  default: state <= `CS_PARSE;
               endcase
            `CS_PARSE:
               case (operator_Q)
                  `CO_LP: state <= `CS_PUSH_OP;
                  `CO_AD: state <= `CS_FLUSH;
                  `CO_SB: state <= `CS_FLUSH;
                  `CO_MU: state <= `CS_FLUSH;
                  `CO_DI: state <= `CS_FLUSH;
                  `CO_RP: state <= `CS_FLUSH;
                  default:
                     if (digit_Q == 4'hf)
                        state <= `CS_INPUT; // invalid
                     else
                        state <= `CS_APP;
               endcase
            `CS_X_PARSE:
               case (operator_Q)
                  `CO_LP: state <= `CS_PUSH_OP;
                  `CO_AD: state <= `CS_PUSH_SIGN;
                  `CO_SB: state <= `CS_PUSH_SIGN;
                  `CO_MU: state <= `CS_X_INPUT;
                  `CO_DI: state <= `CS_X_INPUT;
                  `CO_RP: state <= `CS_X_INPUT;
                  default:
                     if (digit_Q == 4'hf)
                        state <= `CS_X_INPUT; // invalid
                     else
                        state <= `CS_CRE;
               endcase
            `CS_BACK:
               if (dt_empty)
                  state <= `CS_INPUT;
               else
                  state <= `CS_BACK_CALC;
            `CS_BACK_CALC:
               state <= `CS_SAVE;
            `CS_SAVE:
               state <= `CS_INPUT;
            `CS_CRE:
               state <= `CS_INPUT;
            `CS_APP:
               if (dt_empty) // invalid
                  state <= `CS_ERROR;
               else
                  state <= `CS_APP_CALC_1;
            `CS_APP_CALC_1:
               state <= `CS_APP_CALC_2;
            `CS_APP_CALC_2:
               state <= `CS_SAVE;
            `CS_CLEAR:
               state <= `CS_X_INPUT;
            `CS_FLUSH:
               if (op_empty)
                  if (operator_Q == `IC_EXRP)
                     state <= `CS_ERROR;
                  else
                     state <= `CS_PUSH_OP;
               else
                  state <= `CS_COMPARE;
            `CS_COMPARE:
               if (pr_res || operator_Q == `CO_RP && op_data != `CO_LP)
                  state <= `CS_EVALUATE;
               else if (operator_Q == `CO_RP && op_data == `CO_LP)
                  state <= `CS_POP_OP;
               else
                  state <= `CS_PUSH_OP;
            `CS_EVALUATE:
               if (dt_empty)
                  state <= `CS_ERROR;
               else if (operator_x_Q == `CO_PS || operator_x_Q == `CO_NS)
                  state <= `CS_CHG_SIGN;
               else
                  state <= `CS_EVALUATE_D;
            `CS_EVALUATE_D:
               if (dt_empty)
                  state <= `CS_ERROR;
               else
                  state <= `CS_EVALUATE_DD;
            `CS_EVALUATE_DD:
               state <= `CS_EVALUATE_SAVE;
            `CS_EVALUATE_SAVE:
               state <= `CS_FLUSH;
            `CS_CHG_SIGN:
               state <= `CS_EVALUATE_SAVE;
            `CS_PUSH_OP:
               state <= `CS_X_INPUT;
            `CS_POP_OP:
               state <= `CS_X_INPUT;
            `CS_PUSH_SIGN:
               state <= `CS_X_INPUT;
            `CS_ERROR:
               state <= `CS_X_INPUT;
         endcase
   
   // executor
   controller_io io(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .in_ack(in_ack), .out_data(out_data), .out_cmd(out_cmd));
   
   controller_reg_command rcmd(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .command_D(command_D), .command_EN(command_EN));
   
   controller_reg_operator rop(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .operator_D(operator_D), .operator_EN(operator_EN));
   
   controller_reg_operator_x ropx(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .operator_x_D(operator_x_D), .operator_x_EN(operator_x_EN));
   
   controller_reg_digit rdg(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .digit_D(digit_D), .digit_EN(digit_EN));
   
   controller_reg_number rnum(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .number_D(number_D), .number_EN(number_EN));
   
   controller_mem_dt mdt(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .dt_cmd(dt_cmd));
   
   controller_mem_op mop(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .op_cmd(op_cmd));
   
   controller_alu calu(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .al_A(al_A), .al_B(al_B), .al_cmd(al_cmd));
   
   controller_precedence cpre(
      .Reset(Reset), .state(state), .in_cmd(in_cmd),
      .command_Q(command_Q), .operator_Q(operator_Q),
      .number_Q(number_Q), .digit_Q(digit_Q),
      .dt_data(dt_data), .dt_empty(dt_empty),
      .op_data(op_data), .op_empty(op_empty),
      .al_C(al_C), .pr_res(pr_res),
      // output
      .pr_A(pr_A), .pr_B(pr_B));
   
endmodule
