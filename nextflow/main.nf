#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.script_dir = "scripts" // Define a parameter for your script directory
params.data_dir = "DATA"
params.results_dir = "RESULTS"

// Variables

// Proceso que emite un saludo por stdout
process process_test {
    output:
	stdout

    script:
    	"""
    	${file("${params.script_dir}/test-script.sh")}
   	"""
}

// Definir workflow y capturar salida
workflow {
	saludo_ch = process_test()
	saludo_ch.view()
	
}

