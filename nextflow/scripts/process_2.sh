#!/bin/bash
#
#data_dir="../DATA"
#
#
#
#num_files=`ls $data_dir | wc -l` 
#echo "Number of files = $num_files" > files_description.txt
#echo "File Name,Length,GC content" >> files_description.txt
#for item in $(ls $data_dir);do
#	file="$data_dir/$item"
#	
#	num_seq=`grep -c "^>" $file`
#	seq_len=`grep -v '^>' $file | wc -c`	
#	#gc_kmer=`grep -v '^>' $file | grep -ic "GC"`
#	g_content=`grep -v '^>' $file | grep -ic "G"`
#	c_content=`grep -v '^>' $file | grep -ic "C"`
#	#gc_percent=$((((( $c_content + $g_content)/$seq_len))*100 )) 
#	let gc=$((g_content+c_content))
#	gc_percent=$(awk "BEGIN { printf \"%.2f\n\", ($gc / $seq_len) *100 }")
#	echo "$item,$seq_len,$gc_percent" >> files_description.txt
#	
#done
#

dir=$1

for file in $(ls $dir);do
	echo "$file"
done
