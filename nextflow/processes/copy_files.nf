// Define the process for copying FASTA files
process COPY_FASTA_FILES {
    // Input:
    // - `num_files`: The number of files to copy (value)
    // - `source_dir`: The directory from which to copy files (path)
    input:
    val trigger_signal
    val num_files
    path source_dir

    // Output:
    // - A channel emitting all copied FASTA files from the 'copied_fasta' directory
    output:
    path "copied_fasta/*", emit: copied_files

    // Script to execute
    script:
    """
    # Create a directory to store the copied FASTA files
    mkdir -p copied_fasta
    echo ${source_dir}
    # Find FASTA files in the source directory (ending with .fna or .fa)
    # Take the first 'num_files' found
    # Copy them into the 'copied_fasta' directory
    find ${file(source_dir)} -maxdepth 1 -name "*.fna" -o -name "*.fa" | head -n ${num_files} | xargs -I {} cp {} copied_fasta/
    """
}
