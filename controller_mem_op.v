reg [`CO_N-1:0] op_data_D;
assign op_data = op_cmd == `SC_PUS ? op_data_D : {`CO_N{1'bz}};

always @(*)
   if (~Reset)
      begin
         op_data_D <= `CO_NO;
         op_cmd <= `SC_NON;
      end
   else
      case (state)
         `CS_FLUSH:
            begin
               op_data_D <= `CO_NO;
               op_cmd <= `SC_TOP;
            end
         `CS_PUSH_OP:
            begin
               op_data_D <= operator_Q;
               op_cmd <= `SC_PUS;
            end
         `CS_POP_OP, `CS_EVALUATE:
            begin
               op_data_D <= `CO_NO;
               op_cmd <= `SC_POP;
            end
         `CS_PUSH_SIGN:
            case (operator_Q)
               `CO_AD:
                  begin
                     op_data_D <= `CO_PS;
                     op_cmd <= `SC_PUS;
                  end
               `CO_SB:
                  begin
                     op_data_D <= `CO_NS;
                     op_cmd <= `SC_PUS;
                  end
               default:
                  begin
                     op_data_D <= `CO_NO;
                     op_cmd <= `SC_NON;
                  end
            endcase
         `CS_ERROR:
            begin
               op_data_D <= `CO_NO;
               op_cmd <= `SC_CLR;
            end
         default:
            begin
               op_data_D <= `CO_NO;
               op_cmd <= `SC_NON;
            end
      endcase
