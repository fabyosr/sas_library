proc format;
picture dtpic
other='%Y-%0m-%0d %0H:%0M:%0S' (datatype=datetime);
run;

data yyyymmdd_hhmmss;
format X dtpic.;
hhmmss = compress(put(time(),time8.),'','dk');
X = datetime();
run;
