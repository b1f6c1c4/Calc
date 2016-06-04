`default_nettype none
`include "INPUT_INTERFACE.v"
module Input_encoder(
	input Clock,
	input Reset,
   input [15:0] key,
   output reg [`IC_N-1:0] cmd
   );
   
   wire NUM1, NUM2, NUM3, NUM4, NUM5, NUM6, NUM7, NUM8, NUM9, NUM0;
   wire OPAD, OPSB, OPMU, OPDI, EXLP, EXRP, CLBK, CLCL, CTOK;
   
   Input_diff d_NUM1(.Clock(Clock), .Reset(Reset),
                     .btn(key[13]), .pressed(NUM1));
   Input_diff d_NUM2(.Clock(Clock), .Reset(Reset),
                     .btn(key[9]), .pressed(NUM2));
   Input_diff d_NUM3(.Clock(Clock), .Reset(Reset),
                     .btn(key[5]), .pressed(NUM3));
   Input_diff d_NUM4(.Clock(Clock), .Reset(Reset),
                     .btn(key[14]), .pressed(NUM4));
   Input_diff d_NUM5(.Clock(Clock), .Reset(Reset),
                     .btn(key[10]), .pressed(NUM5));
   Input_diff d_NUM6(.Clock(Clock), .Reset(Reset),
                     .btn(key[6]), .pressed(NUM6));
   Input_diff d_NUM7(.Clock(Clock), .Reset(Reset),
                     .btn(key[15]), .pressed(NUM7));
   Input_diff d_NUM8(.Clock(Clock), .Reset(Reset),
                     .btn(key[11]), .pressed(NUM8));
   Input_diff d_NUM9(.Clock(Clock), .Reset(Reset),
                     .btn(key[7]), .pressed(NUM9));
   Input_diff d_NUM0(.Clock(Clock), .Reset(Reset),
                     .btn(key[12]), .pressed(NUM0));
   Input_diff d_EXLP(.Clock(Clock), .Reset(Reset),
                     .btn(key[8]), .pressed(EXLP));
   Input_diff d_EXRP(.Clock(Clock), .Reset(Reset),
                     .btn(key[4]), .pressed(EXRP));
   Input_diff d_CTOK(.Clock(Clock), .Reset(Reset),
                     .btn(key[0]), .pressed(CTOK));
   Input_classifier c_OPAD_OPSB(.Clock(Clock), .Reset(Reset),
                                .btn(key[3]), .short(OPAD), .long(OPSB));
   Input_classifier c_OPMU_OPDI(.Clock(Clock), .Reset(Reset),
                                .btn(key[2]), .short(OPMU), .long(OPDI));
   Input_classifier c_CLBK_CLCL(.Clock(Clock), .Reset(Reset),
                                .btn(key[1]), .short(CLBK), .long(CLCL));
   
   always @(*)
      case (1'b1)
         CLCL: cmd <= `IC_CLCL;
         CLBK: cmd <= `IC_CLBK;
         CTOK: cmd <= `IC_CTOK;
         OPMU: cmd <= `IC_OPMU;
         OPDI: cmd <= `IC_OPDI;
         OPAD: cmd <= `IC_OPAD;
         OPSB: cmd <= `IC_OPSB;
         NUM9: cmd <= `IC_NUM9;
         NUM8: cmd <= `IC_NUM8;
         NUM7: cmd <= `IC_NUM7;
         NUM6: cmd <= `IC_NUM6;
         NUM5: cmd <= `IC_NUM5;
         NUM4: cmd <= `IC_NUM4;
         NUM3: cmd <= `IC_NUM3;
         NUM2: cmd <= `IC_NUM2;
         NUM1: cmd <= `IC_NUM1;
         NUM0: cmd <= `IC_NUM0;
         default: cmd <= `IC_NONE;
      endcase
   
endmodule
