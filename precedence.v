`default_nettype none
module precedence(
   input [CO_N-1:0] A,
   input [CO_N-1:0] B,
   output reg lle_rlt
   );
`include "CPU_INTERNAL.v"

   always @(*)
      case (A)
         CO_OK, CO_LP, CO_RP:
            case (B)
               CO_OK, CO_LP, CO_RP: lle_rlt <= 1'b1;
               CO_AD, CO_SB: lle_rlt <= 1'b1;
               CO_AN, CO_OR: lle_rlt <= 1'b1;
               CO_LS: lle_rlt <= 1'b1;
               CO_PS, CO_NS: lle_rlt <= 1'b1;
               default: lle_rlt <= 1'bx;
            endcase
         CO_AD, CO_SB:
            case (B)
               CO_OK, CO_LP, CO_RP: lle_rlt <= 1'b0;
               CO_AD, CO_SB: lle_rlt <= 1'b1;
               CO_AN, CO_OR: lle_rlt <= 1'b1;
               CO_LS: lle_rlt <= 1'b1;
               CO_PS, CO_NS: lle_rlt <= 1'b1;
               default: lle_rlt <= 1'bx;
            endcase
         CO_AN, CO_OR:
            case (B)
               CO_OK, CO_LP, CO_RP: lle_rlt <= 1'b0;
               CO_AD, CO_SB: lle_rlt <= 1'b0;
               CO_AN, CO_OR: lle_rlt <= 1'b1;
               CO_LS: lle_rlt <= 1'b1;
               CO_PS, CO_NS: lle_rlt <= 1'b1;
               default: lle_rlt <= 1'bx;
            endcase
         CO_LS:
            case (B)
               CO_OK, CO_LP, CO_RP: lle_rlt <= 1'b0;
               CO_AD, CO_SB: lle_rlt <= 1'b0;
               CO_AN, CO_OR: lle_rlt <= 1'b0;
               CO_LS: lle_rlt <= 1'b1;
               CO_PS, CO_NS: lle_rlt <= 1'b1;
               default: lle_rlt <= 1'bx;
            endcase
         CO_PS, CO_NS:
            case (B)
               CO_OK, CO_LP, CO_RP: lle_rlt <= 1'b0;
               CO_AD, CO_SB: lle_rlt <= 1'b0;
               CO_AN, CO_OR: lle_rlt <= 1'b0;
               CO_LS: lle_rlt <= 1'b0;
               CO_PS, CO_NS: lle_rlt <= 1'b1;
               default: lle_rlt <= 1'bx;
            endcase
         default: lle_rlt <= 1'bx;
      endcase

endmodule
