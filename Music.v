`default_nettype none
module Music(
   input Clock,
   input Reset,
   input start,
   input [11:0] start_addr,
   input [11:0] stop_addr,
   input interrupt,
   output reg Buzz);
`ifdef SIMULATION
   parameter div = 100;
`else
   parameter div = 3000000;
`endif

   reg [11:0] bound;
   wire [13:0] divisor;
   reg [11:0] pc;
   rom r(Clock, pc, divisor);

   wire ena;
   clock_divider #(div) cd(Clock, Reset, ena);
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         pc <= 12'b0;
      else if (interrupt)
         pc <= bound;
      else if (start)
         pc <= start_addr;
      else if (pc != bound && ena)
         pc <= pc + 12'b1;

   always @(posedge Clock, negedge Reset)
      if (~Reset)
         bound <= 12'b0;
      else if (start)
         bound <= stop_addr;

   reg [13:0] count;
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         begin
            count <= 14'b0;
            Buzz <= 1'b0;
         end
      else if (pc == bound)
         begin
            count <= 14'b0;
            Buzz <= 1'b1;
         end
      else if (~|count)
         begin
            count <= divisor - 14'b1;
            Buzz <= ~Buzz;
         end
      else
         count <= count - 14'b1;

endmodule

module rom(
   input Clock,
   input [11:0] addr,
   output reg [13:0] data
   );

   reg [13:0] rom[0:4095];

   always @(posedge Clock)
      data <= rom[addr];

   initial
      $readmemb("Music.list", rom);

endmodule
