#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Variables
params.source_dir = 'DATA-source'          // Directory containing source FASTA files
params.require = 'requirements.txt'
params.num_files = 5                 // Number of FASTA files to copy for analysis
params.kmer_size = 3                // Kmer size for matching kmer analysis
params.results_dir = "RESULTS"       // Output directory for all results
params.data_dir = "DATA"
params.bin_size=30
params.window_size=10
params.min_thres=1

// Create outpute directories
new File(params.results_dir).mkdirs()
// new File(params.data_dir).mkdirs()

// Include individual process definitions from the 'processes' directory
include { CHECK_AND_INSTALL_LIBS } from './processes/check_libs.nf'
include { COPY_FASTA_FILES } from './processes/copy_files.nf'
include { DESCRIBE_FASTA_FILE    } from './processes/describe_files.nf'
include { FIND_MATCHING_KMERS    } from './processes/find_kmers.nf'
include { GENERATE_GRAPHICS      } from './processes/generate_graphics.nf'
include { GENERATE_GC_GRAPH      } from './processes/generate_graphics.nf'

workflow {
	setup_file_ch = Channel.fromPath(params.require)
        	.ifEmpty { exit 1, "The file specified by params.require does not exist: ${params.require}" }

    //CHECK_AND_INSTALL_LIBS(setup_file_ch)

    //copied_files_ch = COPY_FASTA_FILES(CHECK_AND_INSTALL_LIBS.out.completion_signal, params.num_files, params.source_dir)
    copied_files_ch = COPY_FASTA_FILES(params.num_files, params.source_dir)
    copied_files_ch.flatten().set { single_fasta_files_channel }
    description_results_ch=DESCRIBE_FASTA_FILE(single_fasta_files_channel)
    
    GENERATE_GC_GRAPH(description_results_ch)
	
    fasta_pairs_ch = copied_files_ch
                        .collect() // Collects all items from the channel into a single list
                        .map { files ->
                            def pairs = []
                            // Generate unique pairs (file1, file2) for kmer comparison.
                            // Ensures file1 is lexicographically before file2 to avoid duplicate pairs.
        						for (int i = 0; i < files.size(); i++) {
                                for (int j = i + 1; j < files.size(); j++) {
                                    pairs << tuple(files[i], files[j],params.kmer_size)
        								
                                }
                            } 
                            return pairs
                        }
        			        .flatMap { it }
                      
        kmer_results_ch = FIND_MATCHING_KMERS(fasta_pairs_ch)
  
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

