import matplotlib.pyplot as plt
import pickle
import sys


# Load kmer index
with open(sys.argv[1], 'rb') as file:
    kmer_index = pickle.load(file)

out_name=sys.argv[1].replace(".pkl","")


kmer_list=[]
kmer_freq=[]
for kmer in kmer_index.keys():
    kmer_list.append(kmer)
    kmer_freq.append(len(kmer_index[kmer][0]))

#Common kmers graph
plt.bar(range(len(kmer_freq)), kmer_freq, align='center')
plt.xticks(range(len(kmer_list)), kmer_list, size='small',rotation=90,fontsize=5)

plt.title(out_name)
plt.xlabel('Kmer')
plt.ylabel('Frequency')
plt.savefig(f"{out_name}_commonKmers.png",dpi=500)

