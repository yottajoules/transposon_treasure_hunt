#!/usr/bin/env bash

cd .. #assumed running in src

for map in results/sam/*transposon.sam; do
    samtools view -S -b $map| \
    bedtools bamtobed -i| bedtools sort -i > results/bed/$(basename $map .sam).bed #| \
    #bedtools merge -s -c 1,6 -o count,distinct > results/bed/$(basename $map .sam)_mergedS.bed #not neeeded (few sequences)
done