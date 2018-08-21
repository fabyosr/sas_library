DATA TMP_DATAS;
FORMAT DT_COMPRA 8.;
INFORMAT DT_COMPRA $8.;
INPUT DT_COMPRA;
DATALINES;
20180101
20180201
20180301
20180401
;

RUN;

PROC SQL;

CREATE TABLE TMP_PERIODO AS
SELECT INPUT(PUT(DT_COMPRA,8.),YYMMDD8.) FORMAT=DATE9. AS DT_COMPRA  /* CONVERT YYYYMMDD TO DATE9 */
FROM TMP_DATAS;

QUIT;