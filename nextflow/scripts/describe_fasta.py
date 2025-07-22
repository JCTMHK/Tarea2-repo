from Bio import SeqIO
import json
import sys
import os

def calculate_gc_content(sequence):
    """
    Calculates the GC content of a DNA sequence.
    Handles both uppercase and lowercase 'G' and 'C'.
    Returns 0.0 if the sequence is empty to avoid division by zero.
    """
    gc_count = sequence.count('G') + sequence.count('C') + \
               sequence.count('g') + sequence.count('c')
    if len(sequence) == 0:
        return 0.0
    return (gc_count / len(sequence)) * 100

def describe_fasta(fasta_file_path, output_dir):
    """
    Analyzes a FASTA file to count sequences, calculate total length,
    and average GC content. Stores the results in a JSON file.

    Args:
        fasta_file_path (str): Path to the input FASTA file.
        output_dir (str): Directory where the JSON output file will be saved.
    """
    seq_count = 0
    total_length = 0
    total_gc_content = 0.0 # Sum of GC content percentages for each sequence

    print(f"Analyzing FASTA file: {fasta_file_path}")
    try:
        # Parse the FASTA file using Biopython's SeqIO
        for record in SeqIO.parse(fasta_file_path, "fasta"):
            seq_count += 1
            total_length += len(record.seq)
            total_gc_content += calculate_gc_content(str(record.seq)) # Convert Seq object to string

    except FileNotFoundError:
        print(f"Error: FASTA file not found at {fasta_file_path}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error parsing {fasta_file_path}: {e}", file=sys.stderr)
        sys.exit(1)

    # Calculate average GC content across all sequences
    avg_gc_content = total_gc_content / seq_count if seq_count > 0 else 0.0

    # Prepare the description data as a dictionary
    description = {
        "file_name": os.path.basename(fasta_file_path),
        "sequence_count": seq_count,
        "total_length": total_length,
        "average_gc_content": round(avg_gc_content, 2) # Round to 2 decimal places
    }

    # Construct the output file path
    # Replace common FASTA extensions with an empty string and append '_description.json'
    base_name = os.path.basename(fasta_file_path)
    output_file_name = base_name.replace(".fasta", "").replace(".fa", "") + "_description.json"
    output_path = os.path.join(output_dir, output_file_name)

    # Write the description data to a JSON file
    try:
        with open(output_path, 'w') as f:
            json.dump(description, f, indent=4) # Use indent for pretty printing JSON
        print(f"Description for {fasta_file_path} saved to {output_path}")
    except IOError as e:
        print(f"Error writing description file to {output_path}: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    # Check for correct number of command-line arguments
    if len(sys.argv) != 3:
        print("Usage: python describe_fasta.py <fasta_file_path> <output_dir>", file=sys.stderr)
        sys.exit(1) # Exit if usage is incorrect

    fasta_file = sys.argv[1]
    list_files = fasta_file.split(" ")
    output_directory = sys.argv[2]
    # describe_fasta(fasta_file, output_directory)
    # print(list_files)
    for file in list_files:
        describe_fasta(file, output_directory)