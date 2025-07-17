#!/bin/bash

#Creates DATA directory and copies files from /home/amoya/Data_forTap

#seqDir="/home/amoya/Data_forTap/selected_Genomes"
seqDir=$1
projectDir=$2
mkdir -p $projectDir/DATA
mkdir -p $projectDir/RESULTS
dest=$projectDir/DATA

#echo "----------------------------------"
#echo Project dir: $projectDir
#echo DATA source dir: $seqDir
#echo DATA destiniy dir: $dest
#echo "----------------------------------"

echo "Copying files from $seqDir to $dest"
echo "----------------------------------"
for file in $(ls $seqDir/*.fna | head -n 5);do
	echo "Copying $file to $dest"
	cp $file $dest
done

