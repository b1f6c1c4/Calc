always @(*)
   if (~Reset)
      command_D <= command_Q;
   else
      case (state)
         CS_INPUT, CS_X_INPUT:
            command_D <= in_cmd;
         default:
            command_D <= command_Q;
      endcase
