#!/usr/bin/bash
 
/usr/bin/time -f "00-->%e Sec   %U Sec   %S Sec  " sort one_million.csv > /dev/null &
/usr/bin/time -f "01-->%e Sec   %U Sec   %S Sec  " sort --parallel=01 one_million.csv > /dev/null &
/usr/bin/time -f "02-->%e Sec   %U Sec   %S Sec  " sort --parallel=02 one_million.csv > /dev/null &
/usr/bin/time -f "03-->%e Sec   %U Sec   %S Sec  " sort --parallel=03 one_million.csv > /dev/null &
/usr/bin/time -f "04-->%e Sec   %U Sec   %S Sec  " sort --parallel=04 one_million.csv > /dev/null &
/usr/bin/time -f "05-->%e Sec   %U Sec   %S Sec  " sort --parallel=05 one_million.csv > /dev/null &
/usr/bin/time -f "06-->%e Sec   %U Sec   %S Sec  " sort --parallel=06 one_million.csv > /dev/null &
/usr/bin/time -f "07-->%e Sec   %U Sec   %S Sec  " sort --parallel=07 one_million.csv > /dev/null &
/usr/bin/time -f "08-->%e Sec   %U Sec   %S Sec  " sort --parallel=08 one_million.csv > /dev/null &
/usr/bin/time -f "09-->%e Sec   %U Sec   %S Sec  " sort --parallel=09 one_million.csv > /dev/null &
/usr/bin/time -f "10-->%e Sec   %U Sec   %S Sec  " sort --parallel=10 one_million.csv > /dev/null &
/usr/bin/time -f "20-->%e Sec   %U Sec   %S Sec  " sort --parallel=20 one_million.csv > /dev/null &
/usr/bin/time -f "30-->%e Sec   %U Sec   %S Sec  " sort --parallel=30 one_million.csv > /dev/null &
/usr/bin/time -f "40-->%e Sec   %U Sec   %S Sec  " sort --parallel=40 one_million.csv > /dev/null &
/usr/bin/time -f "50-->%e Sec   %U Sec   %S Sec  " sort --parallel=50 one_million.csv > /dev/null &
 
