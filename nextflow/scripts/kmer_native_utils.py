# Find common kmer native python
def generate_kmers_with_positions(sequence, k):
    """
    Generate a k-mer dictionary with a list of the start position.
    e.g.: {'AGC': [0, 5, 7], ...}
    """
    kmers_dict = {}
    for i in range(len(sequence) - k + 1):
        kmer = str(sequence[i:i+k])
        if kmer not in kmers_dict:
            kmers_dict[kmer] = []
        kmers_dict[kmer].append(i)
    return kmers_dict

def find_common_kmers(kmers_dict1, kmers_dict2):
    """
    Finds k-mers that are present in both inputed dictionaries.
    Return k-mer sequence as key and a tuple of two lists with the positions
    in both sequences
    e.g.: {'AGC': ([0, 5, 7], [10, 20, 30]), ...}
    """
    common_kmers = {}
    for kmer, positions1 in kmers_dict1.items():
        if kmer in kmers_dict2:
            common_kmers[kmer] = (positions1, kmers_dict2[kmer])
    return common_kmers
