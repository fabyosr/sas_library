
FILENAME DIRLIST PIPE "dir \b /sasdata/Fabyo/*.txt";
                                      
/* CRIA BASE COM ARQUIVOS DA PASTA */ 
DATA TMP_DIR_LIST;
  INFILE DIRLIST LRECL=200 TRUNCOVER;
  INPUT ARQUIVO_A_PROCESSAR $200.;
RUN;
