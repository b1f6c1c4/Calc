always @(*)
   if (~Reset)
      in_ack <= 1'b0;
   else
      case (state)
         CS_INPUT, CS_X_INPUT:
            in_ack <= 1'b1;
         default:
            in_ack <= 1'b0;
      endcase

always @(*)
   if (~Reset)
      begin
         out_data <= {`OD_N{1'b0}};
         out_cmd <= `OC_NON;
      end
   else
      case (state)
         CS_INPUT:
            if (in_cmd == `IC_CLCL)
               begin
                  out_data <= {`OD_N{1'b0}};
                  out_cmd <= `OC_ACK;
               end
            else
               begin
                  out_data <= {`OD_N{1'b0}};
                  out_cmd <= `OC_NON;
               end
         CS_PARSE:
            case (operator_Q)
               `CO_LP, `CO_AD, `CO_SB, `CO_MU, `CO_DI, `CO_RP, `CO_OK:
                  begin
                     out_data <= {`OD_N{1'b0}};
                     out_cmd <= `OC_ACK;
                  end
               default:
                  if (digit_Q != 4'hf)
                     begin
                        out_data <= {`OD_N{1'b0}};
                        out_cmd <= `OC_ACK;
                     end
                  else
                     begin
                        out_data <= {`OD_N{1'b0}};
                        out_cmd <= `OC_NON;
                     end
            endcase
         CS_X_PARSE:
            case (operator_Q)
               `CO_LP, `CO_AD, `CO_SB, `CO_OK:
                  begin
                     out_data <= {`OD_N{1'b0}};
                     out_cmd <= `OC_ACK;
                  end
               default:
                  if (digit_Q != 4'hf)
                     begin
                        out_data <= {`OD_N{1'b0}};
                        out_cmd <= `OC_ACK;
                     end
                  else
                     begin
                        out_data <= {`OD_N{1'b0}};
                        out_cmd <= `OC_NON;
                     end
            endcase
         CS_BACK_CALC:
            begin
               out_data <= {`OD_N{1'b0}};
               out_cmd <= `OC_ACK;
            end
         CS_SAVE, CS_EVALUATE_SAVE:
            begin
               out_data <= number_Q;
               out_cmd <= `OC_NUM;
            end
         CS_CRE:
            begin
               out_data <= digit_Q;
               out_cmd <= `OC_NUM;
            end
         CS_CLEAR:
            begin
               out_data <= {`OD_N{1'b0}};
               out_cmd <= `OC_NUM;
            end
         CS_ERROR:
            begin
               out_data <= {`OD_N{1'b0}};
               out_cmd <= `OC_ERR;
            end
         default:
            begin
               out_data <= {`OD_N{1'b0}};
               out_cmd <= `OC_NON;
            end
      endcase
