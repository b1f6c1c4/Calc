always @(*)
   if (~Reset)
      operator_x_D <= operator_x_Q;
   else if (state == CS_COMPARE)
      operator_x_D <= op_data;
   else
      operator_x_D <= operator_x_Q;
