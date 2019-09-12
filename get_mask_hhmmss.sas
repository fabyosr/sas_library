data hhmmss;
   hhmmss = compress(put(time(),time8.),'','dk');
run;