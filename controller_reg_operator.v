always @(*)
   if (~Reset)
      operator_D <= operator_Q;
   else if (state == CS_INPUT || state == CS_X_INPUT)
      case (in_cmd)
         IC_OPAD:
            operator_D <= CO_AD;
         IC_OPSB:
            operator_D <= CO_SB;
         IC_OPMU:
            operator_D <= CO_MU;
         IC_OPDI:
            operator_D <= CO_DI;
         IC_OPAN:
            operator_D <= CO_AN;
         IC_OPOR:
            operator_D <= CO_OR;
         IC_OPLS:
            operator_D <= CO_LS;
         IC_EXLP:
            operator_D <= CO_LP;
         IC_EXRP:
            operator_D <= CO_RP;
         IC_CTOK:
            operator_D <= CO_OK;
         default:
            operator_D <= CO_NO;
      endcase
   else
      operator_D <= operator_Q;
