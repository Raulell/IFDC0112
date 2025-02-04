#!/usr/bin/bash

LINES=$(tail -n +2 Electric_Vehicle_Population_Data.csv | wc -l | awk '{print $1}')
COLUMN_NUMBER=$(head -1 Electric_Vehicle_Population_Data.csv | sed 's/;/\n/g' | wc -l)
printf "%-50s %7s %11s \n" "Columna" "Distintos" "Porcentaje"

for i in $(seq 1 $COLUMN_NUMBER); do
  DISTINCT=$(tail -n +2 Electric_Vehicle_Population_Data.csv | cut -d';' -f$i | sort | uniq | wc -l)
  PERCENT=$(bc <<< "scale=4; $DISTINCT / $LINES * 100")
  COLUMN=$(head -1 Electric_Vehicle_Population_Data.csv | cut -d';' -f$i)
  printf "%-50s %7d %10.3f%%\n" "$COLUMN" "$DISTINCT" "$PERCENT"
done
