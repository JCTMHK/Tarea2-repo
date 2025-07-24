// Define the process for describing a single FASTA file
process DESCRIBE_FASTA_FILE {
    input:
        path fasta_file
    output:
        tuple val("${fasta_file.name}"), path("${fasta_file.baseName}_description.json"), emit: description_output

    // Script to execute
    script:
    """
    # Execute the Python script to describe the FASTA file
    # The script outputs a JSON file named after the FASTA file in the current work directory.
    echo "${fasta_file}"
    python3 ${file("scripts/describe_fasta.py")} "${fasta_file}" .
    cp  *.json ${file(params.results_dir)}
    """
}
