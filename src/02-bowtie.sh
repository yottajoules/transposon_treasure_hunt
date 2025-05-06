#!/usr/bin/env bash

cd .. #assumed running in src

export BOWTIE2_INDEXES=$(pwd)/data/genome #Assignment_1/data/genome

#align reads to sacCer3
for file in data/*1.fq.gz; do 
    name=$(basename $file _1.fq.gz)
    echo $name
    bowtie2 -x sacCer3 \
        --very-fast -p 4 \
        -1 data/${name}_1.fq.gz \
        -2 data/${name}_2.fq.gz \
        -S results/sam/${name}_aligned.sam
done