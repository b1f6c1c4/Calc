`default_nettype none
`include "CPU_INTERNAL.v"
module precedence(
   input [`CO_N-1:0] A,
   input [`CO_N-1:0] B,
   output reg lle_rlt
   );
   
   always @(*)
      case (A)
         `CO_LP:
            case (B)
               `CO_LP: lle_rlt <= 1'b1;
               `CO_AD, `CO_SB: lle_rlt <= 1'b1;
               `CO_MU, `CO_DI: lle_rlt <= 1'b1;
               `CO_RP: lle_rlt <= 1'b1;
               default: lle_rlt <= 1'bx;
            endcase
         `CO_AD, `CO_SB:
            case (B)
               `CO_LP: lle_rlt <= 1'b0;
               `CO_AD, `CO_SB: lle_rlt <= 1'b1;
               `CO_MU, `CO_DI: lle_rlt <= 1'b1;
               `CO_RP: lle_rlt <= 1'b1;
               default: lle_rlt <= 1'bx;
            endcase
         `CO_MU, `CO_DI:
            case (B)
               `CO_LP: lle_rlt <= 1'b0;
               `CO_AD, `CO_SB: lle_rlt <= 1'b0;
               `CO_MU, `CO_DI: lle_rlt <= 1'b1;
               `CO_RP: lle_rlt <= 1'b1;
               default: lle_rlt <= 1'bx;
            endcase
         `CO_RP:
            case (B)
               `CO_LP: lle_rlt <= 1'b0;
               `CO_AD, `CO_SB: lle_rlt <= 1'b0;
               `CO_MU, `CO_DI: lle_rlt <= 1'b0;
               `CO_RP: lle_rlt <= 1'b1;
               default: lle_rlt <= 1'bx;
            endcase
         default: lle_rlt <= 1'bx;
      endcase
   
endmodule
