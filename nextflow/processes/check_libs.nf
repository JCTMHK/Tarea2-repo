// Define the process for checking and installing Python libraries
process CHECK_AND_INSTALL_LIBS {
    label 'setup_task'

    input:
        path requirements
    // Output: A dummy file to signal successful completion
    output:
    path 'libs_checked.txt', emit: completion_signal

    // Script to execute
    script:
    """
    # Execute the Python script to check and install libraries
    python3 -m venv python-nextflow-env
    source python-nextflow-env/bin/activate
    python3 ${projectDir}/scripts/check_libs.py ${requirements}

    # Create a dummy file to indicate successful completion of this process
    touch libs_checked.txt
    """
}
