@ECHO OFF
ECHO _________________________________________________________

ECHO Programa: clustalo.exe
ECHO library: libgcc_s_sjlj-1.dll, libgomp-1.dll, libstdc++-6.dll, pthreadGC2-w64.dll

curl "https://raw.githubusercontent.com/eduardo1011/gen_comp_uaemex/main/clustalo.exe" -o clustalo.exe

curl "https://raw.githubusercontent.com/eduardo1011/gen_comp_uaemex/main/libgcc_s_sjlj-1.dll" -o libgcc_s_sjlj-1.dll

curl "https://raw.githubusercontent.com/eduardo1011/gen_comp_uaemex/main/libgomp-1.dll" -o libgomp-1.dll

curl "https://raw.githubusercontent.com/eduardo1011/gen_comp_uaemex/main/libstdc++-6.dll" -o libstdc++-6.dll

curl "https://raw.githubusercontent.com/eduardo1011/gen_comp_uaemex/main/pthreadGC2-w64.dll" -o pthreadGC2-w64.dll

curl "https://raw.githubusercontent.com/eduardo1011/gen_comp_uaemex/main/mview.py" -o mview.py

curl "https://raw.githubusercontent.com/eduardo1011/gen_comp_uaemex/main/ncbiblast.py" -o ncbiblast.py

ECHO Programa: ncbi-blast-2.8.1+-win64.exe
ECHO _________________________________________________________

curl "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.8.1/ncbi-blast-2.8.1+-win64.exe" -o ncbi-blast-2.8.1+-win6.exe

start ncbi-blast-2.8.1+-win6.exe

exit
