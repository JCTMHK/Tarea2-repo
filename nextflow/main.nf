#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Variables
def scripts_dir = "/home/jseba/Documents/UTEM/semester_3/tap/nextflow-test"

// Proceso que emite un saludo por stdout
process process_test {
    tag "test process"
    output:
    stdout

    script:
	"""
	$scripts_dir/test-script.sh
	"""	
}

// Definir workflow y capturar salida
workflow {
    saludo_ch = process_test()
    saludo_ch.view()
}

