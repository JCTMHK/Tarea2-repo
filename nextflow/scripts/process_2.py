from Bio import SeqIO
from Bio.SeqUtils import gc_fraction
import os
import re
import sys
## Read sequences files

# # Implementation 1
# # Describes every sequences in every file
# for file in os.listdir("../DATA"):
#     print("----------------------------------------")
#     print(file)
#     print("----------------------------------------")
#     curFile=SeqIO.to_dict(SeqIO.parse(f"../DATA/{file}", "fasta"))
#     num_seq=len(curFile)
#     print("Number of sequences in file:", num_seq)
#     totalSeqLen=0
#     count=1
#     for key in curFile:
#             seqLen=len(curFile[key].seq)
#             GCPercent=gc_fraction(curFile[key].seq)*100
#             totalSeqLen+=seqLen
#             print(f"File,SeqName,SeqLen,GC-Percent,")
#             print(f"\t{count}. Name:",key)
#             print("\t\tSeq Len:", seqLen)
#             print(f"\t\tGC content (%): {GCPercent:.2f}")
#             count+=1
#     print("Total Seq Len in file:", totalSeqLen)
#     print("----------------------------------------")


# Implementation 2
# Describes only file
dataDir=sys.argv[1]
# resultsDir=sys.argv[2]
# output=os.path.join(resultsDir,"descriptions.csv")
# output="descriptions.csv"
output=sys.argv[2]
# print(output)
with open(output, "w") as f:
    f.write(f"File,NumSeq,TotalSeqLen,TotalGC-Percent\n")
    # print(f"File,NumSeq,TotalSeqLen,TotalGC-Percent")
    for file in dataDir.split(" "):
#     for file in os.listdir(dataDir):
        print(file)
        curFile=SeqIO.to_dict(SeqIO.parse(file, "fasta"))
        num_seq=len(curFile)
        totalSeqLen=0
        gcSum=0
        count=1
        for key in curFile:
                seqLen=len(curFile[key].seq)
                gCon = len(re.findall("G", str(curFile[key].seq),re.IGNORECASE))
                cCon = len(re.findall("C", str(curFile[key].seq),re.IGNORECASE))
                gcSum+=(gCon+cCon)
                GCPercent=gc_fraction(curFile[key].seq)*100
                totalSeqLen+=seqLen
        totalGC=(gcSum/totalSeqLen)*100
        # Print or write to file
        # print(f"{file},{num_seq},{totalSeqLen},{totalGC:.2f}")
        f.write(f"{file},{num_seq},{totalSeqLen},{totalGC:.2f}\n")




# # Implementation 3
# # Describe only file with GC kmer count
# print(f"File,NumSeq,TotalSeqLen,TotalGC-Percent")
# for file in os.listdir("../DATA"):
#     curFile=SeqIO.to_dict(SeqIO.parse(f"../DATA/{file}", "fasta"))
#     num_seq=len(curFile)
#     totalSeqLen=0
#     gcKmerSum=0
#     count=1
#     for key in curFile:
#             seqLen=len(curFile[key].seq)
#             gcCon = len(re.findall("GC", str(curFile[key].seq),re.IGNORECASE))
#             totalSeqLen+=seqLen
#             gcKmerSum+=gcCon
#     totalGC=(gcKmerSum/totalSeqLen)*100
   
#     print(f"{file},{num_seq},{totalSeqLen},{totalGC:.2f}")


