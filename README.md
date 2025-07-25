# Tarea 2 TAP

Descripción:
Pipeline que genera análisis simples entre archivos FASTA.

Input:
- 2 o más archivos FASTA.
- Parámetros para realizar análisis.

Output:
- Archivo .json con descripción de cada archivo FASTA de entrada
- Gráfico de alineamiento de kmeros comunes.
- Gráfico de recurrencia basado en kmeros comunes. 
- Gráfico de porcentaje de GC en cada archivo FASTA.
Carpeta nextflow contiene todos los archivos para correr
Datos a ser analizados deben ser colocados en la carpeta nextflow/DATA
Para correr toda la pipeline, executar script run.sh

Carpeta script contiene todos los scripts para procesar los archivos.



Instrucciones de uso:
- Entrar a la carpeta 'nextflow'
- Instalar conda y asegurarse de que este corriendo
- Instalar ambiente conda
```
conda env create -f environment.yml
```
- Activar ambiente conda
```
conda activate pipeline
```
- Ingresar al archivo nexflow.config.
- Modificar 'source_dir' con la ruta absoluta del directorio que contiene los archivos FASTA (necesario).
- Modifcar parámetros de análisis (opcional).
- Ingresar a la carpeta nexflow
- Executar el comando
```
nextflow run main.nf
```
- Cambiar el entorno de execución

## Execución en diferentes perfiles

Execución local
```
nextflow run main.nf -profile local
```

Execución en HPC
```
nextflow run main.nf -profile hpc
```
Autor:
Juan Cantos

Afiliación:
Universidad Tecnológica Metropolitana de Chile
