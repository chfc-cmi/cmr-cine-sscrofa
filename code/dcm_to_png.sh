#!/bin/bash

mkdir -p data/png/images
for j in data/raw/images/*
do
	ID=$(basename $j)
	echo $ID
	SLICE=$(ls $j | cut -f1 -d"_" | sort -nr | head -n1)
	for i in $(ls $j/*/*.dcm | sort -V)
	do
		out=$(echo $i | perl -ne '/(\d+)_BEATS/;printf "'$ID'_slice%03d",('$SLICE'-$1);/i(\d+).dcm/;printf "_frame%03d-image.png\n",($1-1)')
		dcm2pnm --write-png --use-window 1 $i data/png/images/$out
	done
done

# remove non-ES and non-ED labels by intersecting all observers
# quality of manual segmentation is only guaranteed for these timepoints
# thus, only these should be used
\ls data/png/masks/* | sort | uniq -c | awk '$1!=3 {print $2}' | grep mask.png | perl -pe '$_="rm data/png/masks/*/".$_' | bash
