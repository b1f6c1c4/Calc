localparam CS_N = 5;

// IMPORTANT: stack operation need 2 cycles (1 extra state)

// Initial: CS_X_INPUT


/* wait for input (after digit); load operator & digit
input IC_CLBK: CS_BACK
input IC_CLCL: CS_CLEAR; output ACK
input NUM/OP : CS_PARSE
*/
localparam CS_INPUT = 5'h00;

/* wait for input (after operator); load operator & digit
input NUM/OP : CS_X_PARSE
*/
localparam CS_X_INPUT = 5'h01;


/*
op CO_LP: CS_PUSH_OP; output ACK
op CO_RP: CS_FLUSH; output ACK
op CO_OK: CS_FLUSH; output ACK
op ASMD   : CS_FLUSH; output ACK
nm        : CS_APP; output ACK
*/
localparam CS_PARSE = 5'h02;

/* load operator & digit
op CO_LP: CS_PUSH_OP; output ACK
op CO_RP: CS_X_INPUT (invalid)
op AS     : CS_PUSH_SIGN; output ACK
op MD     : CS_X_INPUT (invalid)
nm        : CS_CRE; output ACK
*/
localparam CS_X_PARSE = 5'h03;


/* pop-dt
dt empty: CS_INPUT
dt not  : CS_BACK_CALC
*/
localparam CS_BACK = 5'h04;

/* number = dt / 10; output ACK
any: CS_SAVE
*/
localparam CS_BACK_CALC = 5'h05;

/* push-dt number; output NUM
any: CS_INPUT
*/
localparam CS_SAVE = 5'h06;

/* push-dt digit; output NUM
any: CS_INPUT
*/
localparam CS_CRE = 5'h07;


/* pop-dt
dt empty: CS_ERROR
dt not  : CS_APP_CALC_1
*/
localparam CS_APP = 5'h08;

/* number = dt * 10
any: CS_APP_CALC_2
*/
localparam CS_APP_CALC_1 = 5'h09;

/* number += digit
any: CS_SAVE
*/
localparam CS_APP_CALC_2 = 5'h0a;


/* pop-dt; output NUM 0
dt empty: CS_X_INPUT
dt not  : CS_X_INPUT
*/
localparam CS_CLEAR = 5'h0b;


/* top-op
op empty && operator==CO_RP: CS_ERROR
op empty && ABMD   : CS_PUSH_OP
op not : CS_COMPARE
*/
localparam CS_FLUSH = 5'h0c;

/* operator_x = op; compare operator op
operator==CO_RP && op==CO_LP: CS_POP_OP
lle-rlt || operator==CO_RP && op~=CO_LP: CS_EVALUATE
otherwise: CS_PUSH_OP
*/
localparam CS_COMPARE = 5'h0d;


/* pop-dt; pop-op
dt empty: CS_ERROR
operator_x==SIGN: CS_CHG_SIGN
otherwise: CS_EVALUATE_D
*/
localparam CS_EVALUATE = 5'h0e;

/* number = dt; pop-dt
dt empty: CS_ERROR
otherwise: CS_EVALUATE_DD
*/
localparam CS_EVALUATE_D = 5'h0f;

/* number = dt operator_x number
any: CS_EVALUATE_SAVE
*/
localparam CS_EVALUATE_DD = 5'h10;

/* push-dt number; output number
any: CS_FLUSH
*/
localparam CS_EVALUATE_SAVE = 5'h11;

/* number = 0 P/M dt
any: CS_EVALUATE_SAVE
*/
localparam CS_CHG_SIGN = 5'h12;


/* push-op operator
any: CS_X_INPUT
*/
localparam CS_PUSH_OP = 5'h13;

/* pop-op
any: CS_INPUT
*/
localparam CS_POP_OP = 5'h14;

/* push-op PS/NS
any: CS_X_INPUT
*/
localparam CS_PUSH_SIGN = 5'h15;

/* clear dt; clear op; output ERR
any: CS_X_INPUT
*/
localparam CS_ERROR = 5'h16;
