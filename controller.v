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
         state <= `CS_INPUT;
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
                  `IC_CLBK: state <= `CS_X_INPUT; // invalid
                  `IC_CLCL: state <= `CS_X_INPUT; // invalid
                  `IC_NONE: state <= `CS_X_INPUT;
                  default: state <= `CS_PARSE;
               endcase
            `CS_BACK:
               if (dt_empty) // invalid
                  state <= `CS_INPUT;
               else
                  state <= `CS_BACK_D;
            `CS_BACK_D:
               state <= `CS_BACK_CALC;
            `CS_BACK_CALC:
               state <= `CS_SAVE;
            `CS_SAVE:
               state <= `CS_INPUT;
            `CS_CLEAR:
               state <= `CS_CLEAR;
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
