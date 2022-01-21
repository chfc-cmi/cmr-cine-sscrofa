#!/bin/bash

# USAGE: code/con_to_tsv.sh [mask_folder]
# e.g.: code/con_to_tsv.sh obs0_rep0

OUTDIR="data/intermediate/masks/$1"
mkdir -p $OUTDIR

echo -e "id\tcolumns\trows\tslices" >$OUTDIR/resolution.tsv
for i in data/raw/masks/$1/*.con
do
	ID=$(basename $i .con)
	# add info to resolution.tsv
	echo -ne "$ID\t" >>$OUTDIR/resolution.tsv
	grep Image_resolution $i | cut -f2 -d"=" | tr x "\t" | tr "\n" "\t" >>$OUTDIR/resolution.tsv
	grep -c selection.slice $i >>$OUTDIR/resolution.tsv
	# create tsv file with contours
	perl -ne 'chomp;if($current && / /){print "$_ $current\n"} else {if($skip){$skip=0;}else{$current=0;}} if($newstart){$current=$_;$newstart=0;$skip=1};if(/XYCONTOUR/){$newstart = 1}' $i >$OUTDIR/$ID.tsv
done
