`default_nettype none
module stack(
   input Clock,
   input Reset,
   inout [N-1:0] data,
   output is_empty,
   input [SC_N-1:0] cmd
   );
   parameter N = 16;
`include "STACK_INTERFACE.v"

   reg WE;
   reg [5:0] ram_addr;
   wire [N-1:0] buff;
   ram #(.N(N), .M(6)) memory(.Clock(Clock), .Reset(Reset),
                              .WE(WE), .A(ram_addr), .D(data), .Q(buff));

   reg [5:0] ptr;
   reg out_ena;
   assign data = out_ena ? buff : {N{1'bz}};
   assign is_empty = ~|ptr;

   always @(*)
      if (~Reset)
         ram_addr <= 6'b0;
      else
         case (cmd)
            SC_PUS:
               ram_addr <= ptr;
            SC_POP:
               ram_addr <= ptr - 6'b1;
            SC_TOP:
               ram_addr <= ptr - 6'b1;
            SC_ALT:
               ram_addr <= ptr - 6'b1;
            SC_CLR:
               ram_addr <= ptr;
            default:
               ram_addr <= 6'bx;
         endcase

   always @(*)
      if (~Reset)
         WE = 1'b0;
      else
         case (cmd)
            SC_PUS:
               WE = 1'b1;
            SC_ALT:
               if (|ptr)
                  WE = 1'b1;
               else
                  WE = 1'b0;
            default:
               WE = 1'b0;
         endcase

   always @(posedge Clock, negedge Reset)
      if (~Reset)
         begin
            ptr <= 6'b0;
            out_ena <= 1'b0;
         end
      else
         case (cmd)
            SC_PUS:
               begin
                  ptr <= ptr + 6'b1;
                  out_ena <= 1'b0;
               end
            SC_POP:
               if (|ptr)
                  begin
                     ptr <= ptr - 6'b1;
                     out_ena <= 1'b1;
                  end
            SC_TOP:
               if (|ptr)
                  begin
                     out_ena <= 1'b1;
                  end
            SC_ALT:
               if (|ptr)
                  out_ena <= 1'b0;
            SC_CLR:
               begin
                  ptr <= 6'b0;
                  out_ena <= 1'b0;
               end
            default:
               out_ena <= 1'b0;
         endcase

endmodule

module ram(
   input Clock,
   input Reset,
   input WE,
   input [M-1:0] A,
   input [N-1:0] D,
   output reg [N-1:0] Q
   );
   parameter N = 16;
   parameter M = 6;

   reg [N-1:0] ram[0:2**M];

   always @(posedge Clock, negedge Reset)
      if (~Reset)
         Q <= {N{1'b0}};
      else if (WE)
         ram[A] <= D;
      else
         Q <= ram[A];

endmodule
