process FIND_MATCHING_KMERS {
    input:
     tuple path(fasta1), path(fasta2), val(kmer_size)

    output:
        tuple path("ref_kmer*.pkl"), path("query_kmer*.pkl"), path("ref*-v-query*-*kmers.pkl"), emit: kmer_matches

    script:
    """
    # Execute the Python kmer module script
    # It takes two FASTA files, kmer size, and an output directory (current work directory)
    # and generates a text file with matching kmers.
    python3 ${file("scripts/kmer_module.py")} ${fasta1} ${fasta2} ${kmer_size}
    """
}
