// Define the process for finding matching kmers between two FASTA files
process FIND_MATCHING_KMERS {
    // Input:
    // - `fasta1`: Path to the first FASTA file
    // - `fasta2`: Path to the second FASTA file
    // - `kmer_size`: The size of kmers to find (integer value)
    input:
     tuple path(fasta1), path(fasta2), val(kmer_size)

    // Output:
    // - A tuple containing:
    //   - The name of the first seq file
    //   - The name of the second seq file
    //   - The path to the generated text file containing matching kmers
    output:
        tuple path("ref_kmer*.pkl"), path("query_kmer*.pkl"), path("ref*-v-query*-*kmers.pkl"), emit: kmer_matches

    // Script to execute
    //python ${file("scripts/kmer_module.py")} ${fasta1} ${fasta2} ${kmer_size}
    script:
    """
    # Execute the Python kmer module script
    # It takes two FASTA files, kmer size, and an output directory (current work directory)
    # and generates a text file with matching kmers.
    python ${file("scripts/kmer_module.py")} ${fasta1} ${fasta2} ${kmer_size}
    """
}
