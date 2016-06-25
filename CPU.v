`default_nettype none
module CPU(
   input Clock,
   input Reset,
   output in_ack,
   input [IC_N-1:0] in_cmd,
   output [OD_N-1:0] out_data,
   output [OC_N-1:0] out_cmd
   );
`include "INPUT_INTERFACE.v"
`include "OUTPUT_INTERFACE.v"
`include "STACK_INTERFACE.v"
`include "ALU_INTERFACE.v"
`include "CPU_INTERNAL.v"
   
   // memory
   wire [CD_N-1:0] dt_data;
   wire dt_empty;
   wire [SC_N-1:0] dt_cmd;
   wire [CO_N-1:0] op_data;
   wire op_empty;
   wire [SC_N-1:0] op_cmd;
   stack #(CD_N) dt(
      .Clock(Clock), .Reset(Reset),
      .data(dt_data), .is_empty(dt_empty), .cmd(dt_cmd));
   stack #(CO_N) op(
      .Clock(Clock), .Reset(Reset),
      .data(op_data), .is_empty(op_empty), .cmd(op_cmd));
   
   // alu
   wire [CD_N-1:0] al_A, al_B, al_C;
   wire [AC_N-1:0] al_cmd;
   alu #(CD_N) al(.A(al_A), .B(al_B),
                   .cmd(al_cmd), .C(al_C));
   
   // precedence rom
   wire [CO_N-1:0] pr_A, pr_B;
   wire pr_res;
   precedence prec(.A(pr_A), .B(pr_B), .lle_rlt(pr_res));
   
   // register
   wire [IC_N-1:0] command_D, command_Q;
   register #(IC_N) r_command(
      .Clock(Clock), .Reset(Reset),
      .D(command_D), .Q(command_Q));
   
   wire [CO_N-1:0] operator_D, operator_Q;
   register #(CO_N) r_operator(
      .Clock(Clock), .Reset(Reset),
      .D(operator_D), .Q(operator_Q));
   
   wire [CO_N-1:0] operator_x_D, operator_x_Q;
   register #(CO_N) r_operator_x(
      .Clock(Clock), .Reset(Reset),
      .D(operator_x_D), .Q(operator_x_Q));
   
   wire [CD_N-1:0] number_D, number_Q;
   register #(CD_N) r_number(
      .Clock(Clock), .Reset(Reset),
      .D(number_D), .Q(number_Q));
   
   wire [3:0] digit_D, digit_Q;
   register #(4) r_digit(
      .Clock(Clock), .Reset(Reset),
      .D(digit_D), .Q(digit_Q));
   
   // controller
   controller con(
      .Clock(Clock), .Reset(Reset),
      // io
      .in_ack(in_ack), .in_cmd(in_cmd),
      .out_data(out_data), .out_cmd(out_cmd),
      // register
      .command_D(command_D), .command_Q(command_Q),
      .operator_D(operator_D), .operator_Q(operator_Q),
      .operator_x_D(operator_x_D), .operator_x_Q(operator_x_Q),
      .number_D(number_D), .number_Q(number_Q),
      .digit_D(digit_D), .digit_Q(digit_Q),
      // memory
      .dt_data(dt_data), .dt_empty(dt_empty), .dt_cmd(dt_cmd),
      .op_data(op_data), .op_empty(op_empty), .op_cmd(op_cmd),
      // alu
      .al_A(al_A), .al_B(al_B), .al_C(al_C), .al_cmd(al_cmd),
      // precedence rom
      .pr_A(pr_A), .pr_B(pr_B), .pr_res(pr_res)
      );
   
endmodule
