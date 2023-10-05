#!/bin/bash

fasta="$1"

cC=$(grep -v "^>" $fasta | grep -o "C" | wc -w)

echo "Contenido de Citosinas"
echo $((cC))

cG=$(grep -v "^>" $fasta | grep -o "G" | wc -w)

echo "Contenido de Guaninas"
echo $((cG))

total=$(grep -v "^>" $fasta | grep -o "[ACGT]" | wc -w)

echo "Genoma"
echo $((total))

v=$(($cC+cG))
echo "%GC"
echo "scale=9; $v / $total * 100" | bc
