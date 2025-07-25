# from Res1_1_native import find_common_kmers, generate_kmers_with_positions
# from Res1_1_cython import generate_kmers_with_positions_cython, find_common_kmers_cython
from Bio import SeqIO,Align
import numpy as np
import matplotlib.pyplot as plt
from timeit import default_timer as timer
import pickle
import sys


# Load the dictionaries
# Load sequences
# with open(sys.argv[1], 'rb') as file:
#     refKmer = pickle.load(file)
# with open(sys.argv[2], 'rb') as file:
#     queryKmer = pickle.load(file)

# Load kmer index
with open(sys.argv[1], 'rb') as file:
    kmer_index = pickle.load(file)
# # Load parameters
# with open(sys.argv[4], 'rb') as file:
#     parm_dict = pickle.load(file)



# Parameters
# kmer_size=len(list(kmer_index.keys())[0])
# bin_size=int(sys.argv[4])
# window_size=int(sys.argv[5])
# min_thres=int(sys.argv[6])
# bin_size=250
# window_size=10
# min_thres=1
out_name=sys.argv[1].replace(".pkl","")

# refLen=len(refSeq.seq)
# queryLen=len(querySeq.seq)

# refLen=len(refSeq.seq)
# queryLen=len(querySeq.seq)

# del refSeq
# del querySeq

# Auto-recurrence and cross-recurrence for two sequences
# ----------------------

import numpy as np
import matplotlib.pyplot as plt


kmer_list=[]
kmer_freq=[]
for kmer in kmer_index.keys():
    kmer_list.append(kmer)
    kmer_freq.append(len(kmer_index[kmer][0]))
    # print(kmer,len(kmer_index[kmer][0]))

# plt.show()

#Common kmers graph
plt.bar(range(len(kmer_freq)), kmer_freq, align='center')
plt.xticks(range(len(kmer_list)), kmer_list, size='small',rotation=90,fontsize=5)



# for kmer in refKmer.keys():
#     kmer_list.append(kmer)
#     kmer_freq.append(len(kmer_index[kmer]))

# plt.bar(range(len(kmer_freq)), kmer_freq, align='center')
# plt.xticks(range(len(kmer_list)), kmer_list, size='small', rotation=90,fontsize=5)


# # plt.bar_label(patches1)
# # plt.bar_label(patches2)

plt.title(out_name)
plt.xlabel('Kmer')
plt.ylabel('Frequency')
plt.savefig(f"{out_name}_commonKmers.png",dpi=500)

# plt.legend()
# plt.show()

