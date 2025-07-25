#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Variables
params.require = 'environment.yml'
params.results_dir = "RESULTS"       // Output directory for all results
params.data_dir = "DATA"


// Create output directory
new File(params.results_dir).mkdirs()

// Include individual process definitions from the 'processes' directory
include { COPY_FASTA_FILES } from './processes/copy_files.nf'
include { DESCRIBE_FASTA_FILE    } from './processes/describe_files.nf'
include { FIND_MATCHING_KMERS    } from './processes/find_kmers.nf'
include { GENERATE_GRAPHICS      } from './processes/generate_graphics.nf'
include { GENERATE_GC_GRAPH      } from './processes/generate_graphics.nf'

workflow {
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
  
    GENERATE_GRAPHICS(kmer_results_ch)
}

