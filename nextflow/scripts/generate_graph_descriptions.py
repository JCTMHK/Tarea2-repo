import json
import matplotlib.pyplot as plt
import sys

def read_json_file(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return data

file_name=sys.argv[1].replace(".fna","") 
file_path=sys.argv[2]

pattern = r".*\.json$"



def graphGC(file_path,file_name):
    labels = 'GC', 'AT'
    gc=[]

    parsed_data = read_json_file(file_path)
    gc.append(parsed_data.get('average_gc_content'))
    gc.append((100.0-float(gc[0])))
    fig, ax = plt.subplots()
    ax.set_title(file_name)

    ax.pie(gc,labels=labels,autopct='%1.1f%%')
    plt.savefig(f"{file_name}_gc_content.png",dpi=500)

graphGC(file_path,file_name)


