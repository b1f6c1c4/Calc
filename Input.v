`default_nettype none
module key_scan(
   input CLK,
   input RESET,
   input V1, V2, V3, V4,
   output H1, H2, H3, H4,
   output [7:0] SRCH,
   output [7:0] SRCL,
   output [7:0] DSTH,
   output [7:0] DSTL,
   output reg [IC_N-1:0] ALU_OP,
   output reg finish
   );
`include "INPUT_INTERNAL.v"
`include "INPUT_INTERFACE.v"
   localparam S_SRC1 = 3'h0;
   localparam S_SRC2 = 3'h1;
   localparam S_SRC3 = 3'h2;
   localparam S_OPER = 3'h3;
   localparam S_DST1 = 3'h4;
   localparam S_DST2 = 3'h5;
   localparam S_DST3 = 3'h6;
   localparam S_FINI = 3'h7;
   
   wire Clock = CLK;
   wire Reset = RESET;
   
   wire [15:0] key;
   wire [IC_N-1:0] cmd_t;
   
   // internal reg
   reg [2:0] state;
   reg [15:0] SRC, DST;
   
   // control
   assign SRCH = SRC[15:8];
   assign SRCL = SRC[7:0];
   assign DSTH = DST[15:8];
   assign DSTL = DST[7:0];
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         DST <= IC_ANS;
      else if (cmd_t == IC_CTOK)
         DST <= IC_ANS;
      else
         case (state)
            S_OPER, S_FINI:
               case (cmd_t)
                  IC_NUM0:
                     DST <= 16'd0;
                  IC_NUM1:
                     DST <= 16'd1;
                  IC_NUM2:
                     DST <= 16'd2;
                  IC_NUM3:
                     DST <= 16'd3;
                  IC_NUM4:
                     DST <= 16'd4;
                  IC_NUM5:
                     DST <= 16'd5;
                  IC_NUM6:
                     DST <= 16'd6;
                  IC_NUM7:
                     DST <= 16'd7;
                  IC_NUM8:
                     DST <= 16'd8;
                  IC_NUM9:
                     DST <= 16'd9;
               endcase
            S_DST1, S_DST2, S_SRC1, S_SRC2:
               case (cmd_t)
                  IC_NUM0:
                     DST <= DST * 16'd10 + 16'd0;
                  IC_NUM1:
                     DST <= DST * 16'd10 + 16'd1;
                  IC_NUM2:
                     DST <= DST * 16'd10 + 16'd2;
                  IC_NUM3:
                     DST <= DST * 16'd10 + 16'd3;
                  IC_NUM4:
                     DST <= DST * 16'd10 + 16'd4;
                  IC_NUM5:
                     DST <= DST * 16'd10 + 16'd5;
                  IC_NUM6:
                     DST <= DST * 16'd10 + 16'd6;
                  IC_NUM7:
                     DST <= DST * 16'd10 + 16'd7;
                  IC_NUM8:
                     DST <= DST * 16'd10 + 16'd8;
                  IC_NUM9:
                     DST <= DST * 16'd10 + 16'd9;
               endcase
         endcase
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         ALU_OP <= IC_OPAN;
      else
         case (cmd_t)
            IC_OPAD, IC_OPSB, IC_OPAN, IC_OPOR, IC_OPLS:
               ALU_OP <= cmd_t;
         endcase
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         SRC <= 16'h0;
      else
         case (state)
            S_SRC1, S_SRC2, S_SRC3:
               case (cmd_t)
                  IC_OPAD, IC_OPSB, IC_OPAN, IC_OPOR, IC_OPLS:
                     SRC <= DST;
               endcase
            S_DST1, S_DST2, S_DST3:
               case (cmd_t)
                  IC_CTOK:
                     SRC <= IC_ANS;
               endcase
         endcase
   
   always @(*)
      if (~Reset)
         finish <= 1'b0;
      else if (cmd_t == IC_CTOK)
         case (state)
            S_DST1, S_DST2, S_DST3:
               finish <= 1'b1;
            default:
               finish <= 1'b0;
         endcase
      else
         finish <= 1'b0;
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         state <= S_FINI;
      else
         case (state)
            S_SRC1:
               case (cmd_t)
                  IC_NUM0, IC_NUM1, IC_NUM2, IC_NUM3, IC_NUM4, IC_NUM5, IC_NUM6, IC_NUM7, IC_NUM8, IC_NUM9:
                     state <= S_SRC2;
                  IC_OPAD, IC_OPSB, IC_OPAN, IC_OPOR, IC_OPLS:
                     state <= S_OPER;
               endcase
            S_SRC2:
               case (cmd_t)
                  IC_NUM0, IC_NUM1, IC_NUM2, IC_NUM3, IC_NUM4, IC_NUM5, IC_NUM6, IC_NUM7, IC_NUM8, IC_NUM9:
                     state <= S_SRC3;
                  IC_OPAD, IC_OPSB, IC_OPAN, IC_OPOR, IC_OPLS:
                     state <= S_OPER;
               endcase
            S_SRC3:
               case (cmd_t)
                  IC_OPAD, IC_OPSB, IC_OPAN, IC_OPOR, IC_OPLS:
                     state <= S_OPER;
               endcase
            S_OPER:
               case (cmd_t)
                  IC_NUM0, IC_NUM1, IC_NUM2, IC_NUM3, IC_NUM4, IC_NUM5, IC_NUM6, IC_NUM7, IC_NUM8, IC_NUM9:
                     state <= S_DST1;
               endcase
            S_DST1:
               case (cmd_t)
                  IC_NUM0, IC_NUM1, IC_NUM2, IC_NUM3, IC_NUM4, IC_NUM5, IC_NUM6, IC_NUM7, IC_NUM8, IC_NUM9:
                     state <= S_DST2;
                  IC_CTOK:
                     state <= S_OPER;
               endcase
            S_DST2:
               case (cmd_t)
                  IC_NUM0, IC_NUM1, IC_NUM2, IC_NUM3, IC_NUM4, IC_NUM5, IC_NUM6, IC_NUM7, IC_NUM8, IC_NUM9:
                     state <= S_DST3;
                  IC_CTOK:
                     state <= S_OPER;
               endcase
            S_DST3:
               case (cmd_t)
                  IC_CTOK:
                     state <= S_OPER;
               endcase
            S_FINI:
               case (cmd_t)
                  IC_NUM0, IC_NUM1, IC_NUM2, IC_NUM3, IC_NUM4, IC_NUM5, IC_NUM6, IC_NUM7, IC_NUM8, IC_NUM9:
                     state <= S_SRC1;
                  IC_OPAD, IC_OPSB, IC_OPAN, IC_OPOR, IC_OPLS:
                     state <= S_OPER;
               endcase
         endcase
   
   // main modules
   Input_keyboard keybd(.Clock(Clock), .Reset(Reset),
                        .H({V1,V2,V3,V4}), .V({H1,H2,H3,H4}), .res(key));
   
   Input_encoder enc(.Clock(Clock), .Reset(Reset),
                     .key(key), .cmd(cmd_t));
   
endmodule
