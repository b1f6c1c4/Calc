   always @(*)
      if (~Reset)
         digit_D <= digit_Q;
      else if (state == `CS_INPUT || state == `CS_X_INPUT)
         case (in_cmd)
            `IC_NUM0:
               digit_D <= 4'd0;
            `IC_NUM1:
               digit_D <= 4'd1;
            `IC_NUM2:
               digit_D <= 4'd2;
            `IC_NUM3:
               digit_D <= 4'd3;
            `IC_NUM4:
               digit_D <= 4'd4;
            `IC_NUM5:
               digit_D <= 4'd5;
            `IC_NUM6:
               digit_D <= 4'd6;
            `IC_NUM7:
               digit_D <= 4'd7;
            `IC_NUM8:
               digit_D <= 4'd8;
            `IC_NUM9:
               digit_D <= 4'd9;
            default:
               digit_D <= 4'hf;
         endcase
      else
         digit_D <= digit_Q;
