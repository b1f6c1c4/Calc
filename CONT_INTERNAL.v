`ifndef __CONT_INTERNAL
`define __CONT_INTERNAL

`define CS_N 5

   
// IMPORTANT: stack operation need 2 cycles (1 extra state)

// wait for input (after digit)
`define CS_INPUT 5'h00
// wait for input (after operator)
`define CS_X_INPUT 5'h10

// pop dt
`define CS_BACK 5'h02
// number = dt
`define CS_BACK_D 5'h12
// number %= 10; output ACK
`define CS_BACK_CALC 5'h03
// push number; output NUM
`define CS_SAVE 5'h04

// alt 0; output NUM 0
`define CS_CLEAR 5'h05

// load operator / digit
`define CS_PARSE 5'h01

`endif
