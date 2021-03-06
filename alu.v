`default_nettype none
module alu(
   input signed [N-1:0] A,
   input signed [N-1:0] B,
   input [AC_N-1:0] cmd,
   output reg signed [N-1:0] C
   );
   parameter N = 16;
`include "ALU_INTERFACE.v"

   always @(*)
      case (cmd)
         AC_AD: C <= A + B;
         AC_SB: C <= A - B;
         AC_MU: C <= A * B;
         AC_DI: C <= A / B;
         AC_RM: C <= A % B;
         default: C <= {N{1'bx}};
      endcase

endmodule
