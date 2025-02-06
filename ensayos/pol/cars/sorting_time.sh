#!/usr/bin/bash
 
parallel_values=("00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "20" "30" "40" "50")

for value in "${parallel_values[@]}"; do
    /usr/bin/time -f "$value-->%e Sec   %U Sec   %S Sec  " sort --parallel=$value one_million.csv > /dev/null &
done

wait
