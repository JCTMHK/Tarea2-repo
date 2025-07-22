#!/bin/bash

#Creates DATA directory and copies files from /home/amoya/Data_forTap

#seqDir="/home/amoya/Data_forTap/selected_Genomes"
source=$1
dest=$2
#numFiles=$3
#mkdir -p $projectDir/DATA
#mkdir -p $projectDir/RESULTS
#dest=$projectDir/DATA

#echo "----------------------------------"
#echo Project dir: $projectDir
#echo DATA source dir: $seqDir
#echo DATA destiniy dir: $dest
#echo "----------------------------------"

echo "Copying files from $seqDir to $dest"
echo "----------------------------------"
for file in $(ls $source/*.fna | head -n 5);do
	echo "Copying $file to $dest"
	cp $file $dest
done

