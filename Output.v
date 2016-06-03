`default_nettype none
`include "OUTPUT_INTERFACE.v"
module Output(
	input Clock,
	input Reset,
   input [`OD_N-1:0] data,
   input [`OC_N-1:0] cmd,
	output [0:3] SD,
	output [0:7] SEG,
	output [7:0] LD,
	output Buzz
   );
   
   wire [0:7] oct0, oct1, oct2, oct3;
   wire trig;
   wire [31:0] length;
   wire mono_out;
   
   assign LD = {8{mono_out}};
   assign Buzz = ~mono_out;
   
   Output_scanner scan(.Clock(Clock), .Reset(Reset),
                       .oct0(oct0), .oct1(oct1), .oct2(oct2), .oct3(oct3),
                       .SD(SD), .SEG(SEG));
   
   Output_monostable mono(.Clock(Clock), .Reset(Reset),
                          .trig(trig), .length(length), .out(mono_out));
   
endmodule
