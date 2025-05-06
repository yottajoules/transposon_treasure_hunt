#!/usr/bin/env bash

cd .. #assumed running in src

#find partial mapped pairs, isolating mapped reads
for file in results/sam/*_aligned.sam; do 
    name=$(basename $file _aligned.sam)
    echo $name #debug
    samtools sort -n results/sam/${name}.sam| \
    samtools view -f 1 -F 4 -h | samtools view -f 8 -h > results/sam/${name}_partial.sam
    #filter referenced from explain-SAM-flags website: 
    #-F 4 exlcudes unmapped reads -f 8 includes reads with mate unmapped
done