reg [`CD_N-1:0] dt_data_D;
assign dt_data = dt_cmd == `SC_PUS ? dt_data_D : {`CD_N{1'bz}};

always @(*)
   if (~Reset)
      begin
         dt_data_D <= `CD_0;
         dt_cmd <= `SC_NON;
      end
   else
      case (state)
         `CS_BACK, `CS_APP, `CS_CLEAR, `CS_EVALUATE, `CS_EVALUATE_D:
            begin
               dt_data_D <= `CD_0;
               dt_cmd <= `SC_POP;
            end
         `CS_SAVE, `CS_EVALUATE_SAVE:
            begin
               dt_data_D <= number_Q;
               dt_cmd <= `SC_PUS;
            end
         `CS_CRE:
            begin
               dt_data_D <= digit_Q;
               dt_cmd <= `SC_PUS;
            end
         `CS_ERROR:
            begin
               dt_data_D <= `CD_0;
               dt_cmd <= `SC_CLR;
            end
         default:
            begin
               dt_data_D <= `CD_0;
               dt_cmd <= `SC_NON;
            end
      endcase
