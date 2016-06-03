`default_nettype none
`include "STACK_INTERFACE.v"
module stack(
   input Clock,
   input Reset,
   inout [N-1:0] data,
   input [`SC_N-1:0] cmd
   );
   parameter N = 16;
   
   reg [N-1:0] ram[64];
   reg [5:0] ptr;
   
   reg [N-1:0] buff;
   reg out_ena;
   assign data = out_ena ? buff : {N{1'bz}};
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         begin
            ptr <= 6'b0;
            buff <= {N{1'b0}};
            out_ena <= 1'b0;
         end
      else
         case (cmd)
            `SC_PUS:
               begin
                  ram[ptr] <= data;
                  ptr <= ptr + 6'b1;
                  out_ena <= 1'b0;
               end
            `SC_POP:
               begin
                  buff <= ram[ptr];
                  ptr <= ptr - 6'b1;
                  out_ena <= 1'b1;
               end
            `SC_TOP:
               begin
                  buff <= ram[ptr];
                  out_ena <= 1'b1;
               end
            default:
               out_ena <= 1'b0;
         endcase
   
endmodule
