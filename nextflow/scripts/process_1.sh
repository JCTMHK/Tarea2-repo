#!/bin/bash

#Creates DATA directory and copies files from /home/amoya/Data_forTap

seqDir="/home/amoya/Data_forTap/selected_Genomes"
dest=$1
#mkdir -p $dest

for file in $(ls $seqDir/*.fna | head -n 5);do
	echo "Copying $file to $dest"
	cp $file $dest
done
