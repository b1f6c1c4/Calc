always @(*)
   if (~Reset)
      number_D <= number_Q;
   else
      case (state)
         `CS_BACK_CALC, `CS_APP_CALC_1, `CS_APP_CALC_2,
         `CS_EVALUATE_DD, `CS_EVALUATE_SAVE, `CS_CHG_SIGN:
            number_D <= al_C;
         `CS_EVALUATE_D:
            number_D <= dt_data;
         default:
            number_D <= number_Q;
      endcase
