always @(*)
   if (~Reset)
      begin
         pr_A <= `CO_AD;
         pr_B <= `CO_AD;
      end
   else if (state == CS_COMPARE)
      begin
         pr_A <= operator_Q;
         pr_B <= op_data;
      end
   else
      begin
         pr_A <= `CO_AD;
         pr_B <= `CO_AD;
      end
