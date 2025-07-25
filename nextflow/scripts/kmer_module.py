import sys
from Bio import SeqIO
import random
import os
from kmer_native_utils import generate_kmers_with_positions, find_common_kmers
import pickle



ref=SeqIO.to_dict(SeqIO.parse(sys.argv[1], "fasta"))
query=SeqIO.to_dict(SeqIO.parse(sys.argv[2], "fasta"))
k=int(sys.argv[3])
# Select random sequence
choiceRef = random.choice(list(ref.keys()))
refSeq = ref[choiceRef]
choiceQuery = random.choice(list(query.keys()))
querySeq = query[choiceQuery]


for x in ref.keys():
    if len(ref[x].seq) < len(refSeq.seq):
        refSeq = ref[x]

for y in query.keys():
    if len(query[y].seq) < len(querySeq.seq):
        querySeq = query[y]



del ref
del query

# Generate kmer dictionaries

dict1 = generate_kmers_with_positions(refSeq.seq,k)
dict2 = generate_kmers_with_positions(querySeq.seq,k)

# Match kmers
matches=find_common_kmers(dict1,dict2)

outName=f"ref-{refSeq.name}-v-query-{querySeq.name}-{k}_kmers"

# Save kmer index dict to file
with open(f"{outName}.pkl", 'wb') as file:
    pickle.dump(matches, file)

ref_base_name = os.path.basename(sys.argv[1])
query_base_name = os.path.basename(sys.argv[2])

# Save selected sequences to file
with open(f"ref_seq_{ref_base_name}.pkl", 'wb') as file:
    pickle.dump(refSeq, file)
with open(f"query_seq_{query_base_name}.pkl", 'wb') as file:
    pickle.dump(querySeq, file)

# Save kmer dicts
with open(f"ref_kmer_{ref_base_name}.pkl", 'wb') as file:
    pickle.dump(dict1, file)
with open(f"query_kmer_{query_base_name}.pkl", 'wb') as file:
    pickle.dump(dict2, file)
