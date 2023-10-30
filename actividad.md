---
---
# <span style="color:red">Análisis transcriptómico de *Arabidopsis thaliana*</span>  


### **<span style="color:blue">Esta actividad integra y aplica varios aspectos vistos en clase, tendrán como límite 2 semanas para entregarla, es decir, tienen hasta las 23:59 horas del 9 de noviembre. Lo que deben entregarme es el archivo `At_count.txt` que se genera en el último paso de la actividad. También deben hacer un reporte (me lo mandan en PDF) mostrando capturas de pantalla de las salidas obtenidas en todos los pasos (usando el comando `head`, `ls` o `less` según sea el caso), con esto validaré que tienen las salidas correctas. En el reporte, a cada imagen agreguen un pie de figura que describa brevemente lo que se obtiene.** </span>

---
>>> #### **Nota: La única forma de hacer la actividad es através del servidor.**  
>>> #### **Debes conectarte con tu cuenta de usuario vía `ssh`.**
>>> #### **Debido a la complejidad de la actividad pueden hacer equipos, no olviden poner sus nombres en el reporte.**
>>> #### **Revisa la siguiente imagen para entender cómo debe ser el ambiente de trabajo (directorios) para que los comandos funcionen correctamente.**

<img src="https://raw.githubusercontent.com/eduardo1011/gen_comp_uaemex/main/entorno2.jpg" alt="alt text" title="image Title" width="95%"/>

---
---

#### 1. Descargar los CDS del genoma de *A. thaliana*  
Este archivo es descargado desde este sitio <a href="https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001735.4/" target="_blank">GCF_000001735.4</a>

> >Usa el siguiente comando para descargarlo  

`wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/735/GCF_000001735.4_TAIR10.1/GCF_000001735.4_TAIR10.1_cds_from_genomic.fna.gz`

#### 2. Descomprimir el archivo `GCF_000001735.4_TAIR10.1_cds_from_genomic.fna.gz`  

`gunzip -d GCF_000001735.4_TAIR10.1_cds_from_genomic.fna.gz`

#### 3. Descargar el programa ejecutable Blast para Linux

`wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.8.1/ncbi-blast-2.8.1+-x64-linux.tar.gz`

#### 4. Descomprimir el archivo `ncbi-blast-2.8.1+-x64-linux.tar.gz`  

`tar -xf ncbi-blast-2.8.1+-x64-linux.tar.gz`  

#### 5. Crear un link simólico para `makeblastdb` 
Este programa permite construir bases de datos blast  
En usuario pongan el de ustedes 

`ln -s /storage00/usuario/rna/ncbi-blast-2.8.1+/bin/makeblastdb makeblastdb`  

#### 6. Crear un link simbólico para ejecutar `blastn`  
Este programa permite alineamientos entre secuencias de nucleótidos  
En usuario pongan el de ustedes

`ln -s /storage00/usuario/rna/ncbi-blast-2.8.1+/bin/blastn blastn`

#### 7. Asegurarse de que los archivos fastq se localicen en un directorio, pueden crear un directorio y luego mover los archivos a ese directorio

`mkdir fastqs`

`mv *.fastq fastqs`

#### 8. Crear una carpeta y nombrarla `db`, en este directorio se depositará la base de datos blast
`mkdir db`

### Creación de base de datos Blastn usando el programa `makeblastdb`

#### 9. Construir la base de datos blastn, copia este comando, pégalo en la terminal y ejecútalo

La base  de datos es llamada `ara` haciendo referencia a *`Ara`bidopsis*

`./makeblastdb -in GCF_000001735.4_TAIR10.1_cds_from_genomic.fna -dbtype nucl -parse_seqids -out db/ara`

#### 10. Revisar dentro del directorio `db`, se deben crear archivos binarios de la base de datos (`ara.nhr`, `ara.nin`, `ara.nog`, `ara.nsd`, `ara.nsi` y `ara.nsq`)

`ls db`

### Creación de archivos `fasta`

#### 11. Crear archivos fasta a partir de los archivos fastq. Usando `nano` crea un script de python, copia el siguiente código en el entorno `nano`, guarda (`ctrl + o`) el programa, dale el nombre `convert_fastq_to_fasta.py` y salir del entorno `nano`

```
import sys, os, re
from datetime import datetime

"""
ejemplo:
python3 convert_fastq_to_fasta.py fastqs 10000
"""

folder =  sys.argv[1]
files = [i for i in os.listdir(folder) if '.fastq' in i]

limite = sys.argv[2]

for f in files:
    xx = datetime.now()
    print('+ Processing =', folder+'/'+f)
    fas = open(folder+'/'+f.split('.fastq')[0]+'.fasta', 'w')
    with open(folder+'/'+f) as handle:
        N = 0
        m = 0
        for line in handle:
            line = line.rstrip()
            if m < 4:
                pass
            else:
                m = 0
            if m == 0:
                fas.write(re.sub('@', '>', line)+'\n')
            if m == 1:
                fas.write(line+'\n')
                if N == int(limite):
                    break
                N += 1
            m +=1
    fas.close()
    print('>>>>>> Converted =', folder+'/'+f.split('.fastq')[0]+'.fasta', ' ||| ', 'Time: {}'.format(datetime.now() - xx).split('.')[0])
```


#### 12. Ejecución del script `convert_fastq_to_fasta.py` para crear archivos fasta

>>> Este script requiere 2 argumentos: 1) nombre del directorio donde se encuentran los archivos fastq, y 2) número  de secuencias de los archivos fasta. Este último argumento fue introducido para controlar el número de secuencias, sobre todo para hacer pruebas, por eso para esta actividad usen 1000 (mil) o 10000 (diez mil) o 100000 (cien mil) o 1000000 (un millón), entre más grande sea el número más se tardarán los análisis posteriores. Recomiendo que elijan un valor entre 10000 y 1000000.  

>>> Los archivos `fasta` son guardados en el mismo directorio donde se encuentran los archivos `fastq`

`python3 convert_fastq_to_fasta.py fastqs 10000`

#### 13. Revisar la estructura de los archivos `fasta` generados, ya saben cómo es la estructura

`head fastqs/SRR4420293_1.fasta`

### Alineamiento usando `blastn`

#### 14. Así como se hizo el script del paso 11 en el entorno `nano`, hacer el script llamado `run_blastn.py` con el siguiente código:

>>> Este paso no funcionará si se omite la descarga de blast y la creación del link simbólico, esto se realizó pasos atrás.

```
import subprocess, sys, os

"""
ejemplo:
python3 run_blastn.py fastqs
"""

import subprocess, sys, os

folder =  sys.argv[1]
files = [i for i in os.listdir(folder) if '.fasta' in i]


for h in files:
    f = folder+'/'+h
    print('Blastn =', f)
    su = subprocess.call('./blastn -db db/ara -query '+f+' -evalue 0.00001 -outfmt "6 qacc sacc qlen slen length score bitscore evalue pident nident mismatch positive gaps gapopen stitle" -max_target_seqs 10 -max_hsps 10 -num_threads 8 -out '+h.split('.fasta')[0]+'_blastn.txt', shell = True)
```

#### 15. Una vez creado el script `run_blastn.py` procedemos a ejecutarlo

>>> Este script requiere un argumento: el directorio donde se encuentran los archivos `fasta` creados previamente

>>> Si notas que al ejecutar este script se cierra la conexión con el servidor debido al tiempo de ejecución intenta correrlo en una sesión de `screen`, esto permitirá que se ejecute sin interrupción

`python3 run_blastn.py fastqs`

### Conteo de lecturas por archivo

#### 16. Instalar `numpy` y `pandas` en el servidor

`python3 -mpip install --user numpy`

`python3 -mpip install --user pandas`

>>> Con el siguiente comando puedes comprobar si se instaló, debe aparecer en la lista de módulos

`python3 -mpip list`

#### 17. Así como se hizo el script del paso 11 en el entorno `nano`, hacer el script llamado `get_counts.py` con el siguiente código:

```
from pandas import DataFrame
import pandas as pd
import re, os
import numpy as np
from functools import reduce

"""
ejemplo:
python3 get_counts.py
"""

print('\n')

files = [i for i in os.listdir() if 'blastn.txt' in i]

cols = ['qacc', 'sacc', 'qlen', 'slen', 'length', 'score', 'bitscore', 'evalue', 'pident', 'nident', 'mismatch', 'positive', 'gaps', 'gapopen', 'stitle']

frames = []
for f in files:
    print('+ Processing file=', f)
    df = pd.read_csv(f, names = cols, sep = '\t')
    coeficiente = []
    for (A, B, C, D, E) in zip(df.qlen, df.length, df.pident, df.nident, df.positive):
        A, B, C, D, E = float(A), float(B), float(C), float(D), float(E)
        coeficiente.append(np.std([A, B, C, D, E]) / np.mean([A, B, C, D, E]))
    df['cv'] = coeficiente
    df['sacc'] = [i.split('locus_tag=')[1].split('] [')[0] for i in df.stitle]
    df = df.sort_values(by='cv', ascending=True)
    df2 = df[['qacc', 'sacc', 'qlen', 'pident', 'length', 'nident', 'cv']].drop_duplicates(keep = 'first', subset = 'qacc')
    df2['length'] = df2['length'].astype(float)
    df3 = df2[df2['length'] >= 70].reset_index(drop = True)
    df4 = pd.pivot_table(df3, values = 'qacc', index = 'sacc', aggfunc = len).reset_index()
    df5 = df4.sort_values(by='qacc', ascending=False)
    df5.columns = ['Entry', f.split('.txt')[0]]
    frames.append(df5)
    print('+ > Procesed file=', f)

final = reduce(lambda  left,right: pd.merge(left, right, on = ['Entry'], how = 'outer'), frames).fillna(float(0))

for i in final.columns[1:]:
    final[i] = final[i].astype(int)


final.to_csv('At_count.txt', index = None, sep = '\t')
print('\n')
print('File with all accounts=', 'At_count.txt')
print('\n')
```

#### 18. Una vez instalados los módulos `numpy` y `pandas` y creado el script `get_counts.py` proceder a su ejecución

>>> Este programa toma automáticamente los archivos generados por el script `run_blastn.py`

>>> `get_counts.py` crea automáticamente un archivo llamado `At_count.txt` que contiene las cuentas de las lecturas

`python3 get_counts.py`

#### 19. Exportar (con el comando `scp`) el archivo `At_count.txt` a tu ordenador local y abrirlo con `pandas` en una bitácora de `jupyter`

>>> Del siguiente comando ustedes deben cambiar el nombre de su usuario, recuerden que esta transferencia no se hace con la terminal del servidor sino con una terminal nueva sin conexión al servidor.

`scp usuario@148.215.73.2:/storage00/usuario/rna/At_count.txt .`

>>> Les pedirá su contraseña de usuario

`usuario@148.215.73.2's password:`

>>> Con las siguientes líneas de código visualizan el dataframe en una bitácora de `jupyter`

```
import pandas as pd

df = pd.read_csv('At_count.txt', sep = '\t')
```

>>> El dataframe debe verse como en la siguiente imagen, los valores pueden cambiar en función del número de secuencias que eligieron en el paso 12

<img src="https://raw.githubusercontent.com/eduardo1011/gen_comp_uaemex/main/cuentas_ara.png" alt="alt text" title="image Title" width="95%"/>


 
