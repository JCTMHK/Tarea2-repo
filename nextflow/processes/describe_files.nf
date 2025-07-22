// Define the process for describing a single FASTA file
process DESCRIBE_FASTA_FILE {
    // Input:
    // - `fasta_file`: Path to a single FASTA file
    input:
        // val trigger_signal
        path fasta_file

    // Output:
    // - A tuple containing:
    //   - The original FASTA file's name (for identification)
    //   - The path to the generated JSON description file
    output:
        // stdout
        // tuple path(fasta_file.name), path("${fasta_file.baseName}_description.json"), emit: description_output
        // path("description.csv")

    // Script to execute
    //  #python ${file("scripts/process_2.py")} "${fasta_file}" "${fasta_file.baseName}"
    // python ${file("scripts/describe_fasta.py")} ${fasta_file} .
    // #python ${file("scripts/describe_fasta.py")} ${fasta_file} .

    script:
    """
    # Execute the Python script to describe the FASTA file
    # The script outputs a CSV file named after the FASTA file in the current work directory.
    python ${file("scripts/describe_fasta.py")} "${fasta_file}" .


   

    """
}
