
process COPY_FASTA_FILES {
    input:
        val num_files
        val source_dir

    output:
        path "copied_fasta/*", emit: copied_files

    script:
    """
    mkdir -p copied_fasta
    find ${source_dir} -maxdepth 1 -name "*.fna" -o -name "*.fa" | head -n ${num_files} | xargs -I {} cp {} copied_fasta/
    """
}
