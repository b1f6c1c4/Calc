`default_nettype none
module Calc(
   input CLK,
   input RST,
   input [3:0] H,
   output [3:0] V,
   output [3:0] SD,
   output [7:0] SEG,
   output [7:0] LD,
   output Buzz
   );
`include "INPUT_INTERFACE.v"
`include "ALU_INTERFACE.v"
   localparam S_IDLE = 2'h0;
   localparam S_CALL = 2'h1;
   localparam S_CALH = 2'h2;
   
   assign Buzz = 1'b1;
   assign LD = {dataS[15] && (DST == IC_ANS),
                compare,
                zero,
                carry,
                4'b0};
   
   // fundamental modules
   wire Clock, Reset;
   assign Clock = CLK;
   rst_recover rst(Clock, RST, Reset);
   
   // links
   wire [15:0] SRC, DST;
   wire [IC_N-1:0] ALU_OP;
   wire finish;
   reg [7:0] aluA, aluB;
   wire [7:0] aluS;
   reg aluCin;
   wire aluCout, aluZero;
   reg [15:0] out_data;
   
   // buff
   reg [1:0] state;
   reg [15:0] dataA, dataB, dataS;
   reg zero, carry, compare;
   reg [AC_N-1:0] op;
   
   always @(*)
      case (state)
         S_CALL:
            begin
               aluA <= dataA[7:0];
               aluB <= dataB[7:0];
               aluCin <= 1'b0;
            end
         S_CALH:
            begin
               aluA <= dataA[15:8];
               aluB <= dataB[15:8];
               aluCin <= carry;
            end
         S_IDLE:
            begin
               aluA <= 8'bx;
               aluB <= 8'bx;
               aluCin <= 1'bx;
            end
      endcase
   
   always @(*)
      if (DST == IC_ANS)
         out_data <= dataS;
      else
         out_data <= DST;
   
   always @(posedge Clock, negedge Reset)
      if (~Reset)
         begin
            state <= S_IDLE;
            dataA <= 16'b0;
            dataB <= 16'b0;
            dataS <= 16'b0;
            op <= AC_AN;
            zero <= 1'b0;
            carry <= 1'b0;
            compare <= 1'b0;
         end
      else
         case (state)
            S_IDLE:
               if (finish)
                  begin
                     state <= (ALU_OP == AC_LS ? S_CALH : S_CALL);
                     dataA <= (SRC == IC_ANS ? dataS : SRC);
                     dataB <= DST;
                     op <= ALU_OP;
                     zero <= 1'b0;
                     carry <= 1'b0;
                     compare <= 1'b0;
                  end
            S_CALL:
               case (op)
                  AC_AD, AC_SB, AC_AN, AC_OR:
                     begin
                        state <= S_CALH;
                        dataS[7:0] <= aluS;
                        zero <= aluZero;
                        carry <= aluCout;
                        compare <= 1'b0;
                     end
                  AC_LS:
                     begin
                        state <= S_IDLE;
                        dataS <= aluS;
                        zero <= 1'b0;
                        carry <= 1'b0;
                        compare <= aluS[0];
                     end
               endcase
            S_CALH:
               case (op)
                  AC_AD, AC_SB, AC_AN, AC_OR:
                     begin
                        state <= S_IDLE;
                        dataS[15:8] <= aluS;
                        zero <= zero && aluZero;
                        carry <= aluCout;
                     end
                  AC_LS:
                     if (dataA[15] ^ dataB[15])
                        begin
                           state <= S_IDLE;
                           dataS <= dataB[15];
                           zero <= 1'b0;
                           carry <= 1'b0;
                           compare <= dataB[15];
                        end
                     else if (aluS[0])
                        begin
                           state <= S_IDLE;
                           dataS <= aluS;
                           zero <= 1'b0;
                           carry <= 1'b0;
                           compare <= aluS[0];
                        end
                     else
                        begin
                           state <= S_CALL;
                        end
               endcase
         endcase
   
   // main modules
   key_scan in(.CLK(Clock), .RESET(Reset),
               .V1(H[3]), .V2(H[2]), .V3(H[1]), .V4(H[0]),
               .H1(V[3]), .H2(V[2]), .H3(V[1]), .H4(V[0]),
               .SRCH(SRC[15:8]), .SRCL(SRC[7:0]), .DSTH(DST[15:8]), .DSTL(DST[7:0]),
               .ALU_OP(ALU_OP), .finish(finish));
   alu alu(.CS(op), .data_a(aluA), .data_b(aluB), .carry_in(aluCin),
           .S(aluS), .zero(aluZero), .carry_out(aluCout));
   seg out(.CLK_seg(Clock),
           .data_inH(out_data[15:8]), .data_inL(out_data[7:0]),
           .seg_sel(SD), .data_out(SEG));
   
endmodule
