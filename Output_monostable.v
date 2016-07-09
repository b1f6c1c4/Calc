`default_nettype none
module Output_monostable(
	input Clock,
	input Reset,
	input trig,
	input [31:0] length,
	output reg out
	);

	reg [31:0] count;

	always @(posedge Clock, negedge Reset)
		if (~Reset)
			begin
				count <= 0;
				out <= 1'b0;
			end
		else if (trig)
			begin
				count <= length - 1;
				out <= 1'b1;
			end
		else
			begin
				count <= ~|count ? 0 : count - 1;
				out <= |count;
			end

endmodule
