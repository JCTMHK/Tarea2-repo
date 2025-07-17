#mkdir -p DATA
#mkdir -p RESULTS

#seqDir="/home/amoya/Data_forTap/selected_Genomes"
#dest=DATA
#
#for file in $(ls $seqDir/*.fna | head -n 5);do
#	echo "Copying $file to $dest"
#	cp $file $dest
#done

nextflow run main.nf config local
