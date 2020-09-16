#!/usr/bin/env python
import sys

filein = sys.argv[1]

with open(filein,'r') as f:
    for line in f:
        if line.startswith('Geneid'):
           print(line.strip()) 
        elif sum(map(lambda x:float(x),line.strip().split()[1:])) > 0:
           print(line.strip())
         
        
