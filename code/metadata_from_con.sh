#!/bin/bash

# USAGE: code/metadata_from_con.sh [mask_folder]
# e.g.: code/metadata_from_con.sh obs0_rep0

OUT="data/metadata/$1.tsv"

echo -e "id\tes\ted" >$OUT
for i in data/raw/masks/$1/*.con
do
	ID=$(basename $i .con)
	# add info to resolution.tsv
	echo -ne "$ID\t" >>$OUT
	grep manual_lv_es_phase $i | cut -f2 -d"=" | tr "\n" "\t" >>$OUT
	grep manual_lv_ed_phase $i | cut -f2 -d"=" >>$OUT
done
