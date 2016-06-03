`default_nettype none
`include "ALU_INTERFACE.v"
module alu(
   input signed [N-1:0] A,
   input signed [N-1:0] B,
   input [`AC_N-1:0] cmd,
   output reg signed [N-1:0] C
   );
   parameter N = 16;
   
   always @(*)
      case (cmd)
         `AC_AD: C <= A + B;
         `AC_SB: C <= A - B;
         `AC_MU: C <= A * B;
         `AC_DI: C <= A / B;
         default: C <= {N{1'bx}};
      endcase
   
endmodule
