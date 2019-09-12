DATA TMP_DATAS;
FORMAT DT_COMPRA $8.;
INFORMAT DT_COMPRA $8.;
INPUT DT_COMPRA QTDE_PRODUTO1 QTDE_PRODUTO2;
DATALINES; 
20180101 10 2
20180201 12 3
20180301 13 4
20180401 15 7
20180501 9  9
20180601 7  7
20180701 12 5
20180801 13 8
20180901 15 10
20181001 17 13
20181101 19 17
20181201 20 18
;
RUN;
* geração de arquivo de imagem;
FILENAME GRAFOUT CLEAR;

ODS LISTING CLOSE; /* CLOSE DEFAULT ODS */

FILENAME GRAFOUT "/sasdata/transformacao/00_TMP/Fabyo/compras.png";
ODS LISTING;
GOPTIONS RESET=ALL GSFNAME=GRAFOUT GSFMODE=REPLACE DEVICE=PNG;
%_sas_pushchartsize(1024,400);
LEGEND1 LABEL=NONE FRAME VALUE=("Produto 1" "Produto 2");

PROC GPLOT DATA=TMP_DATAS; * CREATING CHART;
 AXIS1    STYLE=1    WIDTH=1    MINOR=NONE LABEL=( FONT='Arial' HEIGHT=10pt ANGLE=90 ROTATE=0 "VOL.FÍSICO") VALUE=(FONT='Arial' HEIGHT=10pt);
 AXIS2    STYLE=1    WIDTH=1    MINOR=NONE LABEL=( FONT='Arial' HEIGHT=10pt JUSTIFY=CENTER  "DATA DA COMPRA") VALUE=(FONT='Arial' HEIGHT=8pt ANGLE=90);
 SYMBOL1 INTERPOL=JOIN HEIGHT=10pt VALUE=DOT LINE=1 WIDTH=1 COLOR=RED;
 SYMBOL2 INTERPOL=JOIN HEIGHT=10pt VALUE=DOT LINE=1 WIDTH=1 COLOR=GREEN;

 plot QTDE_PRODUTO1*DT_COMPRA QTDE_PRODUTO2*DT_COMPRA/  
 OVERLAY
 LEGEND=legend1
 VAXIS=AXIS1
 HAXIS=AXIS2;
 title1 'Evolução da Compra - Físico';
 title2 'Qtde de Compras'; 
RUN;
/* =====================================================================================
   ENVIO DE EMAIL
   ===================================================================================== */
FILENAME output EMAIL
  SUBJECT= "Evolução de compras"
  /*   */
  TO= ("fabyosr@oi.gmail.com")
  CT= "text/html" /* Required for HTML output */ 
  ATTACH = (
             "/sasdata/Fabyo/compras.png"
           );
  ODS HTML BODY=output STYLE=sasweb options(pagebreak="no") rs=none; /* start ods to html with options, rs=none forces ODS to perform record based output */;
DATA _NULL_;
FILE PRINT;
PUT 'Bom dia,';
PUT 'Segue evolução de compras.';
PUT 'E-mail automático, favor não responder.';
RUN;
DATA TMP_DATA_ADD_TOTAL;
SET TMP_DATAS;
QTDE_TOTAL = QTDE_PRODUTO1+QTDE_PRODUTO2;
RUN;
proc report data=TMP_DATA_ADD_TOTAL nowd split='*'
 style(report)={rules=all cellspacing=1 bordercolor=orange background=orange}
 style(header)={background=cream foreground=black}
 style(column)={background=white foreground=black};

 column DT_COMPRA ('Compras' QTDE_PRODUTO1 QTDE_PRODUTO2)(QTDE_TOTAL);
 define DT_COMPRA /'Período';
 define QTDE_PRODUTO1 /'Produto 1';
 define QTDE_PRODUTO2  /'Produto 2';
 define QTDE_TOTAL  /'Total';

 compute DT_COMPRA;
 if DT_COMPRA=20180101 then
     call define(_row_, "style", "style=[backgroundcolor=cxcc9c00 foreground=WHITE]");
endcomp;
run;
DATA _NULL_;

ods html text = '
                 <div align="center"><img src = "compras.png" align="middle" border="0"></img></div><br>
                 </BODY></HTML>
                ';
RUN;
ODS HTML CLOSE;
