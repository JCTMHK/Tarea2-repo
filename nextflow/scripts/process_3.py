import biotite.sequence as biotite
import sys
from Bio import SeqIO
import random
import os
from Res1_1_native import generate_kmers_with_positions, find_common_kmers
import pickle

## Select random files
# ref = random.choice(os.listdir("../DATA"))
# query = ref
# count=0
# while query == ref:
#     query=random.choice(os.listdir("../DATA"))
#     count+=1
#     if count > 10:
#         break


ref=SeqIO.to_dict(SeqIO.parse(sys.argv[1], "fasta"))
query=SeqIO.to_dict(SeqIO.parse(sys.argv[2], "fasta"))

## Select random sequence
# print(ref.keys())
choiceRef = random.choice(list(ref.keys()))
refSeq =ref[choiceRef]
choiceQuery = random.choice(list(query.keys()))
querySeq =query[choiceQuery]

del ref
del query
del choiceRef
del choiceQuery

# Generate kmer dictionaries
k=10
dict1 = generate_kmers_with_positions(refSeq.seq,k)
dict2 = generate_kmers_with_positions(refSeq.seq,k)

# Match kmers
matches=find_common_kmers(dict1,dict2)

outName=f"ref-{refSeq.name}-v-query-{querySeq.name}-{k}_kmers.pkl"

print(matches)

# Save the dictionary to a file
save_dir="../RESULTS"
with open(outName, 'wb') as file:
    pickle.dump(matches, file)



#  ## Cython
# kmers1_cython = generate_kmers_with_positions_cython(str(seq), k)
# kmers2_cython = generate_kmers_with_positions_cython(str(ref), k)
# common_cython = find_common_kmers_cython(kmers1_cython, kmers2_cython)