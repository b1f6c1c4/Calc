`default_nettype none
`include "INPUT_INTERFACE.v"
timescale 10ns/1ps
module Input_tb();
   
	reg Clock;
	reg Reset;
	wire [3:0] H;
	reg [3:0] V;
   reg ack;
   wire [IC_N-1:0] cmd;
   
   Input mdl(.Clock(Clock), .Reset(Reset),
             .H(H), .V(V),
             .ack(ack), .cmd(cmd));
   
   reg [15:0] connect;
	pulldown p0(H[0]);
	pulldown p1(H[1]);
	pulldown p2(H[2]);
	pulldown p3(H[3]);
	tranif1 t0(H[0], V[0], connect[0]);
	tranif1 t1(H[1], V[0], connect[1]);
	tranif1 t2(H[2], V[0], connect[2]);
	tranif1 t3(H[3], V[0], connect[3]);
	tranif1 t4(H[0], V[1], connect[4]);
	tranif1 t5(H[1], V[1], connect[5]);
	tranif1 t6(H[2], V[1], connect[6]);
	tranif1 t7(H[3], V[1], connect[7]);
	tranif1 t8(H[0], V[2], connect[8]);
	tranif1 t9(H[1], V[2], connect[9]);
	tranif1 ta(H[2], V[2], connect[10]);
	tranif1 tb(H[3], V[2], connect[11]);
	tranif1 tc(H[0], V[3], connect[12]);
	tranif1 td(H[1], V[3], connect[13]);
	tranif1 te(H[2], V[3], connect[14]);
	tranif1 tf(H[3], V[3], connect[15]);
   
   initial
      begin
         Reset = 1'b0;
         #2 Reset = 1'b1;
      end
   
   initial
      begin
         Clock = 1'b1;
         forever
            #2 Clock = ~Clock;
      end
   
   initial
      begin
         
      end
   
endmodule
