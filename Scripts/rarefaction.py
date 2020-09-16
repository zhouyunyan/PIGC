#!/usr/bin/env python
import sys
import numpy as np
import random
import os
from multiprocessing import Pool


filein = sys.argv[1]

steps = range(20,500,20)
step_dict = {}
for each_step in steps:
    step_dict[each_step] = [random.sample(range(1,501),each_step) for i in range(100)]

for each_step in steps:
    filename = 'out'+ str(each_step) + '.txt'
    with open(filename,'w') as f:
	    f.write('ID\tMean\tMin\t25%\t50%\t75%\tMax\n')
        
def process_lines(lines_list,each_step):
    each_step_dict = {}
    out_line = []
    for line in lines:
        iterms = line.strip().split()
        tmp_list = []
        for each_random in step_dict[ each_step ]:
            tmp_list0 = [ iterms[i] for i in each_random]
            tmp_list.append(each_step - tmp_list0.count('0')) 
        out_line.append('\t'.join([iterms[0],
		str(np.mean(tmp_list)),
                str(min(tmp_list)),
                str(np.percentile(tmp_list,25)),
                str(np.percentile(tmp_list,50)),
                str(np.percentile(tmp_list,75)),
                str(max(tmp_list)) ]))
    with open('out'+str(each_step)+'.txt','a') as f2:
        f2.write('\n'.join(out_line)+'\n')
    		
with open(filein,'r') as f:
    #skip the id line
    id_line = f.readline()
    #read 100M data for each time 
    sizehint = 100 * 1024 * 1024  
    position = 0 
    lines = f.readlines(sizehint)
    lines_list = map(lambda x:x.strip().split(),lines)
    pool = Pool(processes=12)
    result = [] 
    for each_step in steps:
        result.append(pool.apply_async(process_lines,[lines_list,each_step]))
    pool.close()
    pool.join()
    while f.tell() - position > 0:
        position = f.tell()
        lines = f.readlines(sizehint)
        lines_list = map(lambda x:x.strip().split(),lines)
        pool = Pool(processes=12)
        result = []
        for each_step in steps:
            result.append(pool.apply_async(process_lines,[lines_list,each_step]))
        pool.close()
        pool.join()
