#!/usr/bin/bash
sed -i -e 's/Clean Alternative Fuel Vehicle Eligible/1/' cars02.csv 
sed -i -e 's/Eligibility unknown as battery range has not been researched/2/' cars02.csv 
sed -i -e 's/Not eligible due to low battery range/3/' cars02.csv 
