always @(*)
   if (~Reset)
      begin
         al_A <= CD_0;
         al_B <= CD_0;
         al_cmd <= AC_AD;
      end
   else
      case (state)
         CS_BACK_CALC:
            begin
               al_A <= dt_data;
               al_B <= 4'd10;
               al_cmd <= AC_DI;
            end
         CS_APP_CALC_1:
            begin
               al_A <= dt_data;
               al_B <= 4'd10;
               al_cmd <= AC_MU;
            end
         CS_APP_CALC_2:
            begin
               al_A <= number_Q;
               al_B <= digit_Q;
               al_cmd <= AC_AD;
            end
         CS_EVALUATE_DD:
            case (operator_x_Q)
               CO_AD:
                  begin
                     al_A <= dt_data;
                     al_B <= number_Q;
                     al_cmd <= AC_AD;
                  end
               CO_SB:
                  begin
                     al_A <= dt_data;
                     al_B <= number_Q;
                     al_cmd <= AC_SB;
                  end
               CO_MU:
                  begin
                     al_A <= dt_data;
                     al_B <= number_Q;
                     al_cmd <= AC_MU;
                  end
               CO_DI:
                  begin
                     al_A <= dt_data;
                     al_B <= number_Q;
                     al_cmd <= AC_DI;
                  end
               default:
                  begin
                     al_A <= CD_0;
                     al_B <= CD_0;
                     al_cmd <= AC_AD;
                  end
            endcase
         CS_CHG_SIGN:
            case (operator_x_Q)
               CO_PS:
                  begin
                     al_A <= CD_0;
                     al_B <= dt_data;
                     al_cmd <= AC_AD;
                  end
               CO_NS:
                  begin
                     al_A <= CD_0;
                     al_B <= dt_data;
                     al_cmd <= AC_SB;
                  end
               default:
                  begin
                     al_A <= CD_0;
                     al_B <= CD_0;
                     al_cmd <= AC_AD;
                  end
            endcase
         default:
            begin
               al_A <= CD_0;
               al_B <= CD_0;
               al_cmd <= AC_AD;
            end
      endcase
