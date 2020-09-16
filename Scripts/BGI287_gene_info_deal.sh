#!/bin/bash

#cmd：bash BGI287_gene_info_deal.sh test.faa
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

python3 - $faa << EOF
import sys
import os
import re
out_list = ['ContigID\tGeneID\tstart\tend\tstrand\tpartial\tGeneLength']
tmp_seq = []
print(sys.argv[1])
with open(sys.argv[1],"r") as f:
    for line in f:
        if line.strip().startswith('>'):
            if tmp_seq:
                if partial == 'Complete':
                    with open("filter.$(basename $faa)",'a') as fout:
                        fout.write('\n'.join(tmp_seq)+'\n')
                tmp_seq = []
            info = re.search(r'^>(.*?) \[(.*)\] (.*) \[(.*)\] (.*$)',line)
            tmp_info = info.groups()
            GeneID  = tmp_info[0]
            ContigID,start,end,strand=tmp_info[2].split('=')[1].split(':')
            partial = tmp_info[-2]
            GeneLength = abs(int(end)-int(start))+1
            out_list.append('{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(ContigID,GeneID,start,end,strand,partial,GeneLength))
            tmp_seq.append(line.strip())
        else:
            tmp_seq.append(line.strip())
            
    if partial == 'Complete':
        with open("filter.$(basename $faa)",'a') as fout:
            fout.write('\n'.join(tmp_seq)+'\n')
                        
    with open("$(basename $faa).txt",'w') as f:
        f.write('\n'.join(out_list))
EOF

