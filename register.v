`default_nettype none
module register(
   input Clock,
   input Reset,
   input [N-1:0] D,
   input EN,
   output reg [N-1:0] Q
   );
   parameter N = 16;
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         Q <= {N{1'b0}};
      else if (EN)
         Q <= D;
   
endmodule
