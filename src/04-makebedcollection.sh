cd .. #assumed running in src
for file in results/sam/*_partial.sam; do #find sam files of partial mapped reads
    name=$(basename $file _partial.sam)
    echo $name #debug
    samtools view -S -b results/sam/${name}.sam > results/sam/${name}.bam
    bedtools bamtobed -i results/sam/${name}.bam| bedtools sort -i > results/bed/${name}.bed #bam to sorted bed

    bedtools merge -i results/bed/${name}.bed -c 1 -o count > results/bed/${name}_merged_insertion_sites.bed #merge with count
    bedtools merge -i results/bed/${name}.bed -s -c 1,6 -o count,distinct > results/bed/${name}_mergedS_insertion_sites.bed #merge with strandedness
done
