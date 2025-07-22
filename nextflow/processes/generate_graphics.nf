// Define the process for generating graphics
process GENERATE_GRAPHICS {
    // Input:
    // - `fasta1_name`: Name of the first FASTA file (string value)
    // - `fasta2_name`: Name of the second FASTA file (string value)
    // - `kmer_file`: Path to the file containing matching kmers
    // - `desc1_file`: Path to the description JSON file for the first FASTA file
    // - `desc2_file`: Path to the description JSON file for the second FASTA file
    // - `results_dir`: The base directory where graphics should be saved (value)
    input:
    // tuple val(ref_pkl), val(query_pkl), path(kmer_file), path(desc1_file), path(desc2_file)
    tuple path(ref_pkl), path(query_pkl), path(kmer_file)
    val bin_size
    val window_size
    val min_thres

    // val results_dir

    // Output:
    // - Channels for different types of plots, emitted to the specified results directory
    // output:
        // stdout
    // path "${results_dir}/*_gc_content.png", emit: gc_plots
    // path "${results_dir}/*_total_length.png", emit: length_plots
    // path "${results_dir}/*_kmers_plot.png", emit: kmer_plots

    script:
    """
    # Execute the Python script to generate various graphics
    # It takes the names of the original FASTA files, the kmer results file,
    # the two description JSON files, and the target output directory.
    
    # echo "Files ${ref_pkl} ${query_pkl} ${kmer_file} ${bin_size} ${window_size} ${min_thres}"
   
    #Script to execute
    python ${file("scripts/generate_graphics.py")} ${ref_pkl} ${query_pkl} ${kmer_file} ${bin_size} ${window_size} ${min_thres}
    """
}