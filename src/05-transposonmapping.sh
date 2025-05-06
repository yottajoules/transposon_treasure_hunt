#!/usr/bin/env bash

cd .. #assumed running in src
export BOWTIE2_INDEXES=$(pwd)/data/genome #Assignment_1/data/genome

#using bed intervals, isolate unmapped reads with mate mapped
NAME=set #original data set name
FILE=results/sam/${NAME}_aligned.sam
REGIONS="chrIV:844205-844928 chrXIV:85532-86190 chrXV:115386-116094" #regions identified from BED

    #apologies, while i recognise that these values can be obtained without the need to hard code (resulting in needing to change params for different datasets)
    #i have decided not to, in the interest of time (to write and debug), but would make a note here:
    #$NAME can be encased in a for loop (spanning line 5 to end of code) with a wildcard to search for each dataset(stu_id)
    #$REGIONS can be obtained by applying appropriate filters to BED files to obtain an array equivalent to above 

samtools view -S -b $FILE| samtools sort > results/sam/${NAME}_aligned.bam
samtools index -b results/sam/${NAME}_aligned.bam -o results/sam/index/${NAME}_aligned_index.bai

for region in $REGIONS; do #for each region, output a filtered SAM file
    samtools view -f 1 -f 4 -h results/sam/${NAME}_aligned.bam -X results/sam/index/${NAME}_aligned_index.bai $region| \
    samtools view -F 8 -F 32 -h > results/sam/${NAME}_${region}_reversed_partial.sam
    #-f 4 unmapped reads
    #specified region
    
    #-F 8 exclude reads with unmapped mate
    #-F 32 mate(mapped) on forward strand
done

for rp in results/sam/*_reversed_partial.sam; do
    echo "make fastq" $rp #echo file
    samtools view -S -b $rp| samtools fastq > data/second/$(basename $rp .sam).fq #make fastq
done

#for each fastq, do bowtie 
for file in data/second/*.fq; do
    echo bowtie #echo bowtie
    bowtie2 -x ty5_6p \
        --very-fast -p 4 \
        -U $file \
        -S results/sam/$(basename $file _reversed_partial.fq)_transposon.sam
done
