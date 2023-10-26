import sys, os, re
from datetime import datetime

folder =  sys.argv[1]
files = [i for i in os.listdir(folder) if '.fastq' in i]

for f in files:
    xx = datetime.now()
    print('+ Processing =', folder+'/'+f)
    fas = open(folder+'/'+f.split('.fastq')[0]+'.fasta', 'w')
    with open(folder+'/'+f) as handle:
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
            m +=1
    fas.close()
    print('>>>>>> Converted =', folder+'/'+f.split('.fastq')[0]+'.fasta', ' ||| ', 'Time: {}'.format(datetime.now() - xx).split('.')[0])
