`default_nettype none
module Output(
	input Clock,
	input Reset,
   input [OD_N-1:0] data,
   input [OC_N-1:0] cmd,
	output [0:3] SD,
	output [0:7] SEG,
	output [7:0] LD,
	output Buzz
   );
   parameter ack_len = 250000;
   parameter err_len = 25000000;
`include "OUTPUT_INTERFACE.v"
   
   // internal nets
   reg data_sign;
   wire [OD_N-1:0] abs_data = data[OD_N-1] ? ~data + 1 : data;
   reg is_err;
   wire out_of_range;
   
   wire [3:0] bcd0, bcd1, bcd2, bcd3;
   wire [0:7] oct0t, oct1t, oct2t, oct3t;
   reg [0:7] oct0, oct1, oct2, oct3;
   reg trig;
   reg [31:0] length;
   wire mono_out;
   
   // output
   assign LD = {8{mono_out}};
   assign Buzz = ~mono_out;
   
   // control
   assign out_of_range = $signed(data) > $signed(9999) || $signed(data) < -$signed(1999);
   
   always @(*)
      case (cmd)
         OC_ACK:
            begin
               trig <= 1'b1;
               length <= ack_len;
            end
         OC_ERR:
            begin
               trig <= 1'b1;
               length <= err_len;
            end
         OC_NUM:
            if ($signed(data) > $signed(9999) || $signed(data) < -$signed(1999))
               begin
                  trig <= 1'b1;
                  length <= err_len;
               end
            else
               begin
                  trig <= 1'b0;
                  length <= 0;
               end
         default:
            begin
               trig <= 1'b0;
               length <= 0;
            end
      endcase
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         data_sign <= 1'b0;
      else if (cmd == OC_NUM)
         data_sign <= data[OD_N-1];
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         is_err <= 1'b0;
      else
         case (cmd)
            OC_ACK: is_err <= 1'b0;
            OC_ERR: is_err <= 1'b1;
            OC_NUM: is_err <= out_of_range;
         endcase
   
   always @(*)
      if (is_err)
         oct0 <= 8'b01100001;
      else if (|bcd3)
         oct0 <= oct0t & (data_sign ? 8'b11111101 : 8'b11111111);
      else
         oct0 <= data_sign ? 8'b11111101 : 8'b11111111;
   
   always @(*)
      if (is_err)
         oct1 <= 8'b01100001;
      else if (|bcd3 || |bcd2)
         oct1 <= oct1t;
      else
         oct1 <= 8'b11111111;
   
   always @(*)
      if (is_err)
         oct2 <= 8'b01100001;
      else if (|bcd3 || |bcd2 || |bcd1)
         oct2 <= oct2t;
      else
         oct2 <= 8'b11111111;
   
   always @(*)
      if (is_err)
         oct3 <= 8'b01100001;
      else
         oct3 <= oct3t;
   
   // main modules
   Output_num_decoder dec0(.bcd(bcd3), .dot(1'b0), .oct(oct0t));
   Output_num_decoder dec1(.bcd(bcd2), .dot(1'b0), .oct(oct1t));
   Output_num_decoder dec2(.bcd(bcd1), .dot(1'b0), .oct(oct2t));
   Output_num_decoder dec3(.bcd(bcd0), .dot(1'b0), .oct(oct3t));
   
   Output_divider divi(.Clock(Clock), .Reset(Reset),
                       .load(cmd == OC_NUM), .data(abs_data),
                       .bcd0(bcd0), .bcd1(bcd1), .bcd2(bcd2), .bcd3(bcd3));
   
   Output_scanner scan(.Clock(Clock), .Reset(Reset),
                       .oct0(oct0), .oct1(oct1), .oct2(oct2), .oct3(oct3),
                       .SD(SD), .SEG(SEG));
   
   Output_monostable mono(.Clock(Clock), .Reset(Reset),
                          .trig(trig), .length(length), .out(mono_out));
   
endmodule
