process DESCRIBE_FASTA_FILE {
    input:
        path fasta_file
    output:
        tuple val("${fasta_file.name}"), path("${fasta_file.baseName}_description.json"), emit: description_output

    script:
    """
    python3 ${file("scripts/describe_fasta.py")} "${fasta_file}" .
    cp  *.json ${file(params.results_dir)}
    """
}
