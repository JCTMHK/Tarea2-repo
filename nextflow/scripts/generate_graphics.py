# from Res1_1_native import find_common_kmers, generate_kmers_with_positions
# from Res1_1_cython import generate_kmers_with_positions_cython, find_common_kmers_cython
from Bio import SeqIO,Align
import numpy as np
import matplotlib.pyplot as plt
from timeit import default_timer as timer
import pickle
import sys

# # Parameters
# refSeq=sys.argv[1]
# querySeq=sys.argv[1]
# kmer_size=sys.argv[1]
# min_thres=sys.argv[1]
# window_size=sys.argv[1]

print("Entering script peko")

# Load the dictionaries
# Load sequences
with open(sys.argv[1], 'rb') as file:
    refSeq = pickle.load(file)
with open(sys.argv[2], 'rb') as file:
    querySeq = pickle.load(file)

# Load kmer index
with open(sys.argv[3], 'rb') as file:
    kmer_index = pickle.load(file)
# # Load parameters
# with open(sys.argv[4], 'rb') as file:
#     parm_dict = pickle.load(file)

# Parameters
kmer_size=len(list(kmer_index.keys())[0])
bin_size=int(sys.argv[4])
window_size=int(sys.argv[5])
min_thres=int(sys.argv[6])
# bin_size=250
# window_size=10
# min_thres=1




# Auto-recurrence and cross-recurrence for two sequences
# ----------------------

import numpy as np
import matplotlib.pyplot as plt

def extract_cross_recurrence_coords(kmer_index, seq1_length, seq2_length):
    """
    Extracts recurrence coordinates for a cross-recurrence plot.

    Args:
        kmer_index (list): List of recurrence information. Each item[2] is an index for seq1,
                           and item[4] is an index for seq2.
        seq1_length (int): Length of the first sequence.
        seq2_length (int): Length of the second sequence.

    Returns:
        tuple: (rows_in_seq1, cols_in_seq2) numpy arrays of recurrence coordinates.
    """


    rows_in_seq1 = []
    cols_in_seq2 = []
    for item in kmer_index.values():
        row, col= item
        for r_idx in row:
            for c_idx in col:
                if 0 <= r_idx < seq1_length and 0 <= c_idx < seq2_length:
                    rows_in_seq1.append(r_idx)
                    cols_in_seq2.append(c_idx)
    return np.array(rows_in_seq1), np.array(cols_in_seq2)

def plot_binned_cross_recurrence(kmer_index, seq1_length, seq2_length, bin_size=10,k=3,file_name=f"recurrence.png"):
    """
    Bins  and plots a cross-recurrence matrix.

    Args:
        kmer_index (list): The list of recurrence information.
        seq1_length (int): The length of the first sequence (N1).
        seq2_length (int): The length of the second sequence (N2).
        bin_size (int): The size of the square bins.
    """
    rows, cols = extract_cross_recurrence_coords(kmer_index, seq1_length, seq2_length)

    if rows.size == 0:
        print("No recurrence points to plot.")
        return
    bins_x = np.arange(0, seq2_length-k+1 + bin_size, bin_size)
    bins_y = np.arange(0, seq1_length-k+1 + bin_size, bin_size)
    H, xedges, yedges = np.histogram2d(cols, rows, bins=(bins_x, bins_y))

    H = H.T
    plt.figure(figsize=(10, 10))
    plt.imshow(H, origin='lower', cmap='hot_r',
               extent=[xedges[0], xedges[-1], yedges[0], yedges[-1]])

    plt.colorbar(label='Number of Recurrences')
    plt.title(f'Binned Cross-Recurrence Plot (Bin Size = {bin_size})\nSeq1 Length: {seq1_length}, Seq2 Length: {seq2_length}')
    plt.xlabel('Sequence 2 Index')
    plt.ylabel('Sequence 1 Index')
    plt.grid(False) 
    plt.gca().set_aspect('equal', adjustable='box')
    plt.tight_layout()

    def make_square_axes(ax):
            """Make an axes square in screen units.
            """
            ax.set_aspect(1 / ax.get_data_ratio())

    make_square_axes(plt.gca())
    plt.savefig(file_name,dpi=500)
    # plt.show()


plot_binned_cross_recurrence(kmer_index, len(refSeq.seq), len(querySeq.seq), bin_size=bin_size,k=kmer_size)

# --------------------------------



# # Sequence alignment
# # ----------------

# def get_candidate_regions(common_kmers, k, seq1_len, seq2_len, window_size=5):
#     """
#     Define candidate regions around common k-mers.
#     window_size: number of characters to expand on each side of k-mer.
#     """
#     candidate_regions = []
#     for kmer, (pos1_list, pos2_list) in common_kmers.items():
#         for p1 in pos1_list:
#             for p2 in pos2_list:
#                 start1 = max(0, p1 - window_size)
#                 end1 = min(seq1_len, p1 + k + window_size)
#                 start2 = max(0, p2 - window_size)
#                 end2 = min(seq2_len, p2 + k + window_size)

#                 candidate_regions.append(((start1, end1), (start2, end2)))

#     return candidate_regions


# def run_smith_waterman_on_regions_for_plot(seq1, seq2, candidate_regions, match_score=2, mismatch_penalty=-1, gap_penalty=-2):
#     aligner = Align.PairwiseAligner()
#     aligner.match_score = match_score
#     aligner.mismatch_score = mismatch_penalty
#     aligner.open_gap_score = gap_penalty
#     aligner.extend_gap_score = gap_penalty
#     aligner.mode = 'local'

#     plot_data = []

#     for (s1_region_start, s1_region_end), (s2_region_start, s2_region_end) in candidate_regions:
#         sub_seq1 = seq1[s1_region_start:s1_region_end]
#         sub_seq2 = seq2[s2_region_start:s2_region_end]

#         if len(sub_seq1) == 0 or len(sub_seq2) == 0:
#             continue

#         alignments = aligner.align(sub_seq1, sub_seq2)

#         if alignments:
#             for alignment in alignments:
#                 if alignment.score > 0:
#                     rel_s1_start = alignment.aligned[0][0][0]
#                     rel_s1_end = alignment.aligned[0][-1][-1]
#                     rel_s2_start = alignment.aligned[-1][0][0]
#                     rel_s2_end = alignment.aligned[-1][-1][-1]

#                     abs_s1_start = s1_region_start + rel_s1_start
#                     abs_s2_start = s2_region_start + rel_s2_start

#                     alignment_length = max(rel_s1_end - rel_s1_start, rel_s2_end - rel_s2_start)

#                     if alignment_length > 0:
#                         plot_data.append({
#                             'x_start': abs_s1_start,
#                             'y_start': abs_s2_start,
#                             'x_end': abs_s1_start + alignment_length,
#                             'y_end': abs_s2_start + alignment_length,
#                             'score': alignment.score,
#                             'length': alignment_length
#                         })

#     return plot_data


# def plot_similarity_dot_plot(plot_data, seq1_len, seq2_len, min_score_threshold=5,file_name="align_window.png"):
#     plt.figure(figsize=(10, 8))

#     for item in plot_data:
#         if item['score'] >= min_score_threshold:
#             x_start = item['x_start']
#             y_start = item['y_start']
#             length = item['length']
#             score = item['score']

#             color_intensity = min(1.0, score / (length * 2))

#             plt.plot([x_start, x_start + length], [y_start, y_start + length],
#                      color=(0, 0, color_intensity),
#                      linewidth=score / 10.0 + 0.5)

#     plt.xlim(0, seq1_len)
#     plt.ylim(0, seq2_len)
#     plt.xlabel(f"Position in sequence 1 (Length: {seq1_len})")
#     plt.ylabel(f"Position in sequence 2 (Length: {seq2_len})")
#     plt.title("self-similarity graph (Dot Plot) of DNA sequences")
#     plt.gca().set_aspect('equal')
#     plt.grid(True, linestyle='--', alpha=0.6)

#     def make_square_axes(ax):
#             """Make an axes square in screen units.
#             """
#             ax.set_aspect(1 / ax.get_data_ratio())

#     make_square_axes(plt.gca())

#     plt.savefig(file_name,dpi=500)
#     # plt.show()


# # Find candidate regions for alignment
# candidate_regions = get_candidate_regions(kmer_index, kmer_size, len(refSeq.seq), len(querySeq.seq), window_size=window_size)

# # Gets data to plot the graph
# plot_data = run_smith_waterman_on_regions_for_plot(refSeq.seq, querySeq.seq, candidate_regions)

# # Execute function to draw graph
# plot_similarity_dot_plot(plot_data, len(refSeq.seq), len(querySeq.seq), min_score_threshold=min_thres)

# # # -----------------------------------------
print("Script graphics finished peko")