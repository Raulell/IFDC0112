#\!/usr/bin/bash
head -1 Electric_Vehicle_Population_Data.csv | sed -e 's/;/:\n/g'| grep -n ':'
