#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.scripts_dir = "scripts" // Define a parameter for your script directory
//params.data_dir = "DATA"
params.results_dir = projectDir/"RESULTS"

def dataDir = "DATA"

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


def localData = file("/home/jseba/Documents/UTEM/semester_3/tap/tarea-2/Tarea2-repo/nextflow/DATA-source")
def remoteData = file("/home/amoya/Data_forTap/selected_Genomes")
// Proceso 1
process process_1 {
	input:
	
	output:
	stdout
	script:
	"""
	${file("${params.scripts_dir}/process_1.sh")} ${localData} ${projectDir}
	"""

}

// Proceso 2

params.data_dir = projectDir/"DATA"
process process_2 {
	output:
		stdout
	script:
	"""
	echo "${params.data_dir}"
	python ${file("${params.scripts_dir}/process_2.py")} ${params.data_dir} ${params.results_dir}
	"""

}

// Proceso 3

params.ref = params.data_dir/"GCA_000807395.3_ASM80739v3_genomic.fna"
params.query = params.data_dir/"GCA_001447175.1_ASM144717v1_genomic.fna"
def kmer=10

process process_3{
	output:
		stdout
	script:
	"""
	python ${file("${params.scripts_dir}/process_3.py")} ${params.ref} ${params.query} ${kmer} 
	"""

}

// Proceso 4

params.require = projectDir/"requirements.txt"
process process_4{
	output:
		stdout
	script:
	"""
	echo ${params.require}
	#python -m pip install -r ${params.require}
	pip install -r ${params.require}
	"""

}
// Proceso 5
params.ref = params.data_dir/"GCA_000807395.3_ASM80739v3_genomic.fna"
params.query = params.data_dir/"GCA_001447175.1_ASM144717v1_genomic.fna"
def kmer=10

process process_3{
	output:
		stdout
	script:
	"""
	python ${file("${params.scripts_dir}/process_3.py")} ${params.ref} ${params.query} ${kmer} 
	"""

}

// Definir workflow y capturar salida
workflow {
	//saludo_ch = process_test()
	//saludo_ch.view()
	//process_1=process_1()
	//process_1.view()
	//process_2=process_2()
	//process_2.view()
	//process_3=process_3()
	//process_3.view()
	//process_4=process_4()
	//process_4.view()
	process_5=process_5()
	process_5.view()



}

