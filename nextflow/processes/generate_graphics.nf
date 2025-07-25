
process GENERATE_GRAPHICS {
    memory = 14.GB
    cpus = 8 
    input:
    
    tuple path(ref_pkl), path(query_pkl), path(kmer_file)
    val bin_size
    val window_size
    val min_thres
	
    script:
    """
    python3 ${file("scripts/generate_graphics.py")} ${kmer_file}
    cp  *.png ${file(params.results_dir)}
    """
}


process GENERATE_GC_GRAPH {
    input:
        tuple val(fasta_name), path(description_file)

    script:
    """
    python3 ${file("scripts/generate_graph_descriptions.py")} ${fasta_name} ${description_file}
    cp  *_gc_content.png ${file(params.results_dir)}
    """



}
