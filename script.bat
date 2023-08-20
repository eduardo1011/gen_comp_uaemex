@ECHO OFF
ECHO _________________________________________________________

ECHO Programa: ncbi-blast-2.8.1+-win64.exe
ECHO _________________________________________________________

curl "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.8.1/ncbi-blast-2.8.1+-win64.exe" -o ncbi-blast-2.8.1+-win6.exe

start ncbi-blast-2.8.1+-win6.exe

exit