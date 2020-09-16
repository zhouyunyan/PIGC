#!/usr/bin/env python
import sys

filein = sys.argv[1]

with open(filein,'r') as f:
    for line in f:
        iterms = line.strip().split()
        if not line.startswith('Geneid'):
            counts_zero = iterms[1:].count('0')
            Count = len(iterms[1:])-counts_zero
            Average = sum(map(lambda x:float(x),iterms[1:]))/len(iterms[1:])           
            print('\t'.join([iterms[0],str(Average),str(Count)]))
        else:
            print('\t'.join([iterms[0],'Average','Count']))
         
        
