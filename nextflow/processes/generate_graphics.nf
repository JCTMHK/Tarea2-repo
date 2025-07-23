
process GENERATE_GRAPHICS {
    
    input:
    
    tuple path(ref_pkl), path(query_pkl), path(kmer_file)
    val bin_size
    val window_size
    val min_thres

    script:
    """
    python ${file("scripts/generate_graphics.py")} ${ref_pkl} ${query_pkl} ${kmer_file} ${bin_size} ${window_size} ${min_thres}
    cp  *.png ${file(params.results_dir)}
    """
}


process GENERATE_GC_GRAPH {
    input:
        tuple val(fasta_name), path(description_file)

    script:
    """
    python ${file("scripts/generate_graph_descriptions.py")} ${fasta_name} ${description_file}
    cp  *_gc_content.png ${file(params.results_dir)}
    """



}