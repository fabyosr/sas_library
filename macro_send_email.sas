%MACRO ENVIO_EMAIL();
  %IF &ENVIAR_EMAIL.>0 %THEN %DO;
      FILENAME MYFILE EMAIL ("fabyosr@gmail.com" "fulano@fulano.net.br" "beltrano.barcellos@hotmail.com" )
      SUBJECT="Processo finalizado com sucesso";
      
      DATA _NULL_;
         FILE MYFILE;
         SET BIG_DATA_RESULT;
         PUT "Bom dia,";
         PUT ' ';
         PUT "Segue resumo do processamento.";
         PUT ' ';
         PUT "- " FIELD_RESULT;
         PUT ' ';
         PUT "E-mail automático, favor não responder.";
      RUN;
  %END;
%MEND;
%ENVIO_EMAIL();