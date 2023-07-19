#!/bin/bash

for accession in ERR10123851 ERR9880850 ERR9769174 ERR10123848 ERR9769173
do
    prefetch $accession
    fastq-dump -I --split-files $accession
done

bwa-mem2.sse41 index mpox_refgenome.fasta

for file in *_1.fastq
do
    bwa-mem2.sse41 mem mpox_refgenome.fasta $file > ${file%_1.fastq}.sam
done

for file in *.sam
do
    samtools view -S -b $file > ${file%.sam}.bam
    samtools view ${file%.sam}.bam | head
    samtools sort ${file%.sam}.bam -o ${file%.sam}.sorted.bam
    samtools index ${file%.sam}.sorted.bam
done

for file in *.sorted.bam
do
    echo "* * * * 1" >> samples.ploidy
done

bcftools mpileup -f mpox_refgenome.fasta *.sorted.bam | bcftools call -mv -Ov --ploidy-file samples.ploidy -o Kharrat_hmpox.bcf

bcftools view Kharrat_hmpox.bcf > Kharrat_hmpox.vcf
