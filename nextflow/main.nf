#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// params.results_dir = projectDir/"RESULTS"

// def dataDir = "DATA"

// Variables
params.source_dir = 'DATA-source'          // Directory containing source FASTA files
params.num_files = 2                 // Number of FASTA files to copy for analysis
params.kmer_size = 10                 // Kmer size for matching kmer analysis
params.results_dir = "results"       // Output directory for all results
params.bin_size=30
params.window_size=10
params.min_thres=1

// Ensure the results directory exists before starting the workflow
// This creates the directory if it doesn't already exist.
// Channel.fromPath(params.results_dir).ifEmpty {
//     log.info "Creating results directory: ${params.results_dir}"
//     new File(params.results_dir).mkdirs()
// }

// Include individual process definitions from the 'processes' directory
include { CHECK_AND_INSTALL_LIBS } from './processes/check_libs.nf'
include { COPY_FASTA_FILES } from './processes/copy_files.nf'
include { DESCRIBE_FASTA_FILE    } from './processes/describe_files.nf'
include { FIND_MATCHING_KMERS    } from './processes/find_kmers.nf'
include { GENERATE_GRAPHICS      } from './processes/generate_graphics.nf'

// // Proceso que emite un saludo por stdout
process process_test {
	publishDir "$params.output_dir"
    output:
		path "test-output.txt"
    script:
   		"""
		mkdir -p copied_fasta
   		${file("${params.scripts_dir}/test-script.sh")} > test-output.txt
	find ${params.source_dir} -maxdepth 1 -name "*.fna" -o -name "*.fa" | head -n ${params.num_files} | xargs -I {} cp {} copied_fasta/ 
   		"""
}


// def localData = file("/home/jseba/Documents/UTEM/semester_3/tap/tarea-2/Tarea2-repo/nextflow/DATA-source")
// def remoteData = file("/home/amoya/Data_forTap/selected_Genomes")

// // Proceso 1
// process process_1 {
// 	label "Process_1"
// 	output:
// 		stdout
// 	script:
// 	"""
// 	mkdir -p ${file(params.data_dir)}
// 	${file("${params.scripts_dir}/process_1.sh")} ${params.source_dir} ${file(params.data_dir)}
// 	"""

// }

// // Proceso 2

// // params.data_dir = projectDir/"DATA"
// process process_2 {
// 	publishDir params.output_dir, mode: 'copy', saveAs: { file -> "${file}" }	
// 	output:
// 		path('descriptions.csv')
// 	script:
// 	"""
// 	python ${file("${params.scripts_dir}/process_2.py")} ${file(params.data_dir)}
// 	"""

// }

// // Proceso 3

// // def ref = params.data_dir/"GCA_000807395.3_ASM80739v3_genomic.fna"
// // def query = params.data_dir/"GCA_001447175.1_ASM144717v1_genomic.fna"

// process process_3{
// 	// publishDir params.output_dir, mode: 'copy', saveAs: { file -> "${file}" }
// 	output:
// 		path "ref*-v-query*.pkl"
// 		path "*seq.pkl"
		
// 	script:
// 	"""
// 	python ${file("${params.scripts_dir}/process_3.py")} ${file("${params.data_dir}/GCA_000807395.3_ASM80739v3_genomic.fna")} ${file("${params.data_dir}/GCA_000807395.3_ASM80739v3_genomic.fna")} ${params.kmer_size} 
// 	"""

// }

// // Proceso 4

// ///params.require = projectDir/"requirements.txt"
// process process_4{
// 	output:
// 		stdout
// 	script:
// 	"""
// 	echo ${params.require}
// 	#python -m pip install -r ${params.require}
// 	pip install -r ${file(params.require)}
// 	"""

// }
// // Proceso 5
// //params.index = params.data_dir/""
// //params.ref_dict = params.results_dir/"ref-*_seq.pkl"
// //params.query_dict = params.results_dir/"query-*_seq.pkl"

// process process_5 {
// 	input: 
// 		path("*_seq.pkl", arity: '2')
// 		path("ref*-v-*query.pkl", arity: '1')

// 	output:
// 		stdout
// 	script:
// 	"""
// 	python ${file("${params.scripts_dir}/process_5.py")} ref_seq.pkl query_seq.pkl "ref*-v-*query.pkl" ${params.bin_size} ${params.window_size} ${params.min_thres} 
// 	"""

// }

// Definir workflow y capturar salida

// Define your channel
// channel
//     .from([[1,2],[3,4],[5,6]])
//     .set(myPairsChannel)


workflow {
	// test = process_test()
	// test.view()
	// process_1=process_1()
	// process_1.view()
	// process_2=process_2()
	// process_2.view()
	// process_3=process_3()
	// process_3.view()
	// process_4=process_4()
	// process_4.view()
	// process_5=process_5(process_3.output)
	// process_5.view()
    CHECK_AND_INSTALL_LIBS(params.require)
    copied_files_ch = COPY_FASTA_FILES(CHECK_AND_INSTALL_LIBS.out.completion_signal, params.num_files, params.source_dir)

	// copied_files_ch = COPY_FASTA_FILES(params.num_files, params.source_dir)
    copied_files_ch.flatten().set { single_fasta_files_channel }
	description_results_ch=DESCRIBE_FASTA_FILE(single_fasta_files_channel)
    
    // Collect all description results into a map for easy lookup in later steps.
    // The map will be: [fasta_file_name: description_file_path]
    description_map = description_results_ch.description_output //.collectEntries()
                        // .map { fasta_name, desc_file -> tuple(fasta_name, desc_file) }  //println "$fasta_name $desc_file" 
                        .collect()
                        // .collectEntries() // Transforms a channel of tuples into a map 
                        // .set { final_description_map_ch }

	// Step 4: Find matching kmers between pairs of FASTA files
    // First, collect all copied files into a list to generate unique pairs.
    fasta_pairs_ch = copied_files_ch
                        .collect() // Collects all items from the channel into a single list
                        .map { files ->
							// println "$files"
                            def pairs = []
                            // Generate unique pairs (file1, file2) for kmer comparison.
                            // Ensures file1 is lexicographically before file2 to avoid duplicate pairs.
							for (int i = 0; i < files.size(); i++) {
								// println i
                                for (int j = i + 1; j < files.size(); j++) {
									// println "$i $j"
                                    pairs << tuple(files[i], files[j],params.kmer_size)
									// println tuple(files[i], files[j], params.kmer_size)
									// println [files[i], files[j], params.kmer_size]
									// [files[i], files[j], params.kmer_size]
									
                                }
                            }
							// println pairs 
                            return pairs
                        }
                        // .flatten() // Flattens the list of pairs into individual (file1, file2) tuples on the channel
				        .flatMap { it } // For each item (which is a list of lists), flatten it
                       // So it transforms [[path,path,val],[path,path,val],[path,path,val]]
                       // into three separate emissions: [path,path,val], [path,path,val], [path,path,val]
        				// .set { single_tuples_channel }
	// Pass the generated pairs and the kmer size to the kmer finding process.
    // The output is a tuple: (fasta1_name, fasta2_name, matching_kmers_file_path)
	kmer_results_ch = FIND_MATCHING_KMERS(fasta_pairs_ch)

	// kmer_results_ch = FIND_MATCHING_KMERS().view()
  // // Step 5: Generate graphics based on kmer matches and file descriptions
    // // This step requires inputs from both the kmer analysis and the description analysis.
    // // We map over the `kmer_results_ch` and use the `description_map` to find the
    // // corresponding description files for each FASTA file involved in the kmer comparison.
    // graphics_input_ch = kmer_results_ch
    //     .map { fasta1_name, fasta2_name, kmer_file ->
    //         // Look up the description file paths using the collected map
    //         def desc1_file = description_map.get(fasta1_name)
    //         def desc2_file = description_map.get(fasta2_name)

    //         // Log warnings and filter out pairs if description files are missing
    //         if (!desc1_file) {
    //             log.warn "Description file not found for ${fasta1_name}. Skipping graphics for this pair."
    //             return null
    //         }
    //         if (!desc2_file) {
    //             log.warn "Description file not found for ${fasta2_name}. Skipping graphics for this pair."
    //             return null
    //         }
    //         // Return a complete tuple for the graphics process
    //         return tuple(fasta1_name, fasta2_name, kmer_file, desc1_file, desc2_file)
    //     }
    //     .filter { it != null } // Filter out any null values (pairs for which description files were missing)

    // Pass the combined input to the graphics generation process, along with the results directory.
    // GENERATE_GRAPHICS(graphics_input_ch, params.results_dir)
    GENERATE_GRAPHICS(kmer_results_ch,params.bin_size,params.window_size,params.min_thres)

    // // Final message to the user upon workflow completion
    // onWorkflowEnd {
    //     if (workflow.success) {
    //         log.info "Workflow completed successfully! Results are in the '${params.results_dir}' directory."
    //     } else {
    //         log.error "Workflow failed! Check the Nextflow logs for details."
    //     }
    // }
}

