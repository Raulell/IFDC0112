#\!/usr/bin/bash
head -1 flags.csv | sed -e 's/:/:\n/g'| grep -n ':'
