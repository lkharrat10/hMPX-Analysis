#!/bin/bash

kmer_length=25

prefetch ERR10123851
fastq-dump -I --split-files ERR10123851


{ (time /home/exouser/Documents/Tools/velvet/velveth run_25_velvet $kmer_length -shortPaired -separate -fastq ERR10123851_1.fastq ERR10123851_2.fastq) 2> time_mem_velvet.txt && ps -p $$ -o rss=,%cpu= >> time_mem_velvet.txt; (time /home/exouser/Documents/Tools/velvet/velvetg run_25_velvet -exp_cov auto -cov_cutoff auto) 2>> time_mem_velvet.txt && ps -p $$ -o rss=,%cpu= >> time_mem_velvet.txt; } 2>&1

{ (time python3 /home/exouser/Documents/Tools/bin/spades.py -1 ERR10123851_1.fastq -2 ERR10123851_2.fastq -k $kmer_length -o run_25_spades) 2> time_mem_spades.txt && ps -p $$ -o rss=,%cpu= >> time_mem_spades.txt; } 2>&1

{ (time python3 /home/exouser/Documents/Tools/quast/quast.py -r mpox_refgenome.fasta run_25_velvet/contigs.fa run_25_spades/contigs.fasta run_25_unicycler/run_25_unicycler_contigs.fasta) 2> time_mem_quast.txt && ps -p $$ -o rss=,%cpu= >> time_mem_quast.txt; } 2>&1

