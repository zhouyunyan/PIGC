#!/bin/bash

#cmd：bash Sample500_gene_info_deal.sh test.faa
set -e
faa=$1

if [ $# != 1 ];then
	   echo "bash $0 faa"
	      exit
fi

source /etc/profile
script_dir=$( cd $(dirname $0); pwd -P )
echo $script_dir
thread=$( cat /proc/cpuinfo | grep processor |wc -l)
mem=$(free -m | grep 'Mem' | awk '{print int(0.9*$2)}')
echo "threads:$thread"
echo "MEM:$mem"

#define workdir
#workdir=$( date +%s%20N | md5sum | awk '{print $1}' )
#mkdir $workdir 

python - $faa << EOF
import sys
import os
import re
out_list = ['ContigID\tGeneID\tstart\tend\tstrand\tpartial\tGC\tGeneLength']
tmp_seq = []
with open(sys.argv[1],"r") as f:
    for line in f:
        if line.strip().startswith('>'):
            if tmp_seq:
                if partial == '00':
                    with open("filter.$(basename $faa)",'a') as fout:
                        fout.write('\n'.join(tmp_seq)+'\n')
                tmp_seq = []
            info = re.match(r'^>(.*)_(\d+) # (\d+) # (\d+) # (.*?) # ID=(.*?);partial=(\d+);(.*?);gc_cont=(.*?)$',line.strip())
            info = info.groups()
            ContigID = info[0]
            start = info[2]
            end = info[3]
            strand = info[4]
            partial = info[6]
            GC = info[-1]
            GeneLength = abs(int(end) - int(start))
            GeneID = line.strip().split()[0].strip('>')

            out_list.append('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(ContigID,GeneID,start,end,strand,partial,GC,GeneLength))
            tmp_seq.append(line.strip())
        else:
            tmp_seq.append(line.strip())

    with open("$(basename $faa).txt",'w') as f:
        f.write('\n'.join(out_list))
EOF				