#!/bin/bash

#Creates DATA directory and copies files from /home/amoya/Data_forTap

seqDir="/home/amoya/Data_forTap/selected_Genomes"
mkdir -p DATA

for file in $(ls $seqDir/*.fna | head -n 5);do
	echo "cp $file DATA"
	cp $file DATA
done
