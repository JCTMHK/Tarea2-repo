* **Autor:** Juan Cantos
* **Afiliación:** Universidad Tecnológica Metropolitana
* **Repositorio:** https://github.com/JCTMHK/Tarea2-repo.git

# Descripción
Pipeline que genera análisis simples de archivos FASTAS.
  - Extracción de kmeros
  - Comparación de kmeros entre secuencias
  - Contenido de GC
  - Longitud secuencias
  - Cantidad de secuencias por archivo *FASTA*

## Estructura
```
Tarea2-repo/
├── nextflow
│   ├── environment.yml
│   ├── main.nf
│   ├── nextflow.config
│   ├── processes
│   │   ├── copy_files.nf
│   │   ├── describe_files.nf
│   │   ├── find_kmers.nf
│   │   └── generate_graphics.nf
│   └── scripts
│       ├── describe_fasta.py
│       ├── generate_graph_descriptions.py
│       ├── generate_graphics.py
│       ├── kmer_module.py
│       └── kmer_native_utils.py

└── README.md
```
* README.md: Este archivo
* nextflow: Todos los componentes del proyecto
* scripts: Scripts de python que generan los diferentes análisis
* processes: Carpetas con scripts de nextflow donde se definen los diferentes procesos del pipeline
* environment.yml: Archivo para configuración de ambiente conda

# Instrucciones

**Input:**
- 2 o más archivos FASTA.
- Parámetros para realizar análisis.

**Output:**
- Archivo .json con descripción de cada archivo FASTA de entrada
- Gráfico de frecuencia de kmeros cómunes entre dos secuencias 
- Gráfico de porcentaje de GC en cada archivo FASTA.

**Ejecución:**
- Entrar a la carpeta 'nextflow'
- Asegurarse de que conda esté instalado y corriendo
- Instalar ambiente conda
```
conda env create -f environment.yml
```
- Activar ambiente conda
```
conda activate pipeline
```
- Ingresar al archivo nexflow.config.
- Modificar 'source_dir' con la ruta absoluta del directorio que contiene los archivos FASTA (**necesario**).
- Modifcar parámetros de análisis (**opcional**)
- Executar el comando
```
nextflow run main.nf
```

## Execución en diferentes perfiles

**Execución local:**
```
nextflow run main.nf -profile local
```

**Execución en HPC (slurm):**
```
nextflow run main.nf -profile hpc
```


# Detalles de desarrollo
**Descripción del entorno de desarrollo:**
  * **Sistema operativo:**
    * Ubuntu 22.04.5 LTS x86_64
  * **Hardware:**
    * Intel i7-8650U (8) @ 4.200GHz
    * 16 GB RAM


* **Versiones de los software, lenguajes y librearías:**
  * Python 3.10.18
  * Bipython 1.78
  * Matplotlib 3.10
  * Numpy 1.26.4
  * pip 25.1

