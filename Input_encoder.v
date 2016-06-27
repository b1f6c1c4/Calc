`default_nettype none
module Input_encoder(
	input Clock,
	input Reset,
   input [15:0] key,
   output reg [IC_N-1:0] cmd
   );
`include "INPUT_INTERFACE.v"
   
   wire NUM1, NUM2, NUM3, NUM4, NUM5, NUM6, NUM7, NUM8, NUM9, NUM0;
   wire OPAD, OPSB, OPMU, OPDI, OPAN, OPOR, OPLS, EXLP, EXRP, CLBK, CLCL, CTOK;
   
   Input_diff d_NUM1(.Clock(Clock), .Reset(Reset),
                     .btn(key[15]), .pressed(NUM1));
   Input_diff d_NUM2(.Clock(Clock), .Reset(Reset),
                     .btn(key[11]), .pressed(NUM2));
   Input_diff d_NUM3(.Clock(Clock), .Reset(Reset),
                     .btn(key[7]), .pressed(NUM3));
   Input_diff d_NUM4(.Clock(Clock), .Reset(Reset),
                     .btn(key[3]), .pressed(NUM4));
   Input_diff d_NUM5(.Clock(Clock), .Reset(Reset),
                     .btn(key[14]), .pressed(NUM5));
   Input_diff d_NUM6(.Clock(Clock), .Reset(Reset),
                     .btn(key[10]), .pressed(NUM6));
   Input_diff d_NUM7(.Clock(Clock), .Reset(Reset),
                     .btn(key[6]), .pressed(NUM7));
   Input_diff d_NUM8(.Clock(Clock), .Reset(Reset),
                     .btn(key[2]), .pressed(NUM8));
   Input_diff d_NUM9(.Clock(Clock), .Reset(Reset),
                     .btn(key[13]), .pressed(NUM9));
   Input_diff d_NUM0(.Clock(Clock), .Reset(Reset),
                     .btn(key[9]), .pressed(NUM0));
   Input_classifier c_OPAN_EXLP(.Clock(Clock), .Reset(Reset),
                                .btn(key[12]), .short(OPAN), .long(EXLP));
   Input_classifier c_OPOR_EXRP(.Clock(Clock), .Reset(Reset),
                                .btn(key[8]), .short(OPOR), .long(EXRP));
   Input_classifier c_OPAD_OPMU(.Clock(Clock), .Reset(Reset),
                                .btn(key[5]), .short(OPAD), .long(OPMU));
   Input_classifier c_OPSB_OPDI(.Clock(Clock), .Reset(Reset),
                                .btn(key[1]), .short(OPSB), .long(OPDI));
   Input_classifier c_OPLS_CLBK(.Clock(Clock), .Reset(Reset),
                                .btn(key[4]), .short(OPLS), .long(CLBK));
   Input_classifier c_CTOK_CLCL(.Clock(Clock), .Reset(Reset),
                                .btn(key[0]), .short(CTOK), .long(CLCL));
   
   always @(*)
      case (1'b1)
         CLCL: cmd <= IC_CLCL;
         CLBK: cmd <= IC_CLBK;
         CTOK: cmd <= IC_CTOK;
         OPMU: cmd <= IC_OPMU;
         OPDI: cmd <= IC_OPDI;
         OPAD: cmd <= IC_OPAD;
         OPSB: cmd <= IC_OPSB;
         OPAN: cmd <= IC_OPAN;
         OPOR: cmd <= IC_OPOR;
         OPLS: cmd <= IC_OPLS;
         EXLP: cmd <= IC_EXLP;
         EXRP: cmd <= IC_EXRP;
         NUM9: cmd <= IC_NUM9;
         NUM8: cmd <= IC_NUM8;
         NUM7: cmd <= IC_NUM7;
         NUM6: cmd <= IC_NUM6;
         NUM5: cmd <= IC_NUM5;
         NUM4: cmd <= IC_NUM4;
         NUM3: cmd <= IC_NUM3;
         NUM2: cmd <= IC_NUM2;
         NUM1: cmd <= IC_NUM1;
         NUM0: cmd <= IC_NUM0;
         default: cmd <= IC_NONE;
      endcase
   
endmodule
