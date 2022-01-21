#!/usr/bin/env python

# USAGE: python code/tsv_to_png.py [mask_folder]
# e.g.: python code/tsv_to_png.py obs0_rep0

# This script converts medis contour files (previously converted to tsv) to png images.
# It is assumed that each timepoint is either labeled completely or not at all, thus implicitly missing contours for some slices of a timepoint are filled with empty masks

import os
import sys
import pandas as pd
import matplotlib.pyplot as plt
from PIL import Image, ImageDraw
import numpy as np
from tqdm import tqdm

folder = sys.argv[1]

volunteers = pd.read_csv(f"data/intermediate/masks/{folder}/resolution.tsv",sep="\t",index_col="id")
output_folder = f'data/png/masks/{folder}'

os.makedirs(output_folder, exist_ok=True)

for volunteerId,volunteer in tqdm(volunteers.iterrows()):
    contour = pd.read_csv("data/intermediate/masks/{}/{}.tsv".format(folder,volunteerId),sep=" ",names=["x","y","z","t","c"],usecols=range(5))
    timepoints = contour.iloc[:,3].drop_duplicates().to_numpy()
    for t in tqdm(timepoints, leave=False):
        for z in tqdm(range(volunteer.slices), leave=False):
            poly = [(x[0],x[1]) for x in contour[contour.z==z][contour.t==t][contour.c==1].to_numpy()[:,0:2]]
            if len(poly)==0:
                Image.new('I', (volunteer.columns, volunteer.rows), 0).save('{}/{}_slice{:03d}_frame{:03d}-mask.png'.format(output_folder,volunteerId,z,t))
            else:
                img = Image.new('L', (volunteer["columns"], volunteer["rows"]), 0)
                if(len(poly)>1):
                    ImageDraw.Draw(img).polygon(poly, outline=1, fill=1)
                mask = np.array(img)
                poly2 = [(x[0],x[1]) for x in contour[contour.z==z][contour.t==t][contour.c==0].to_numpy()[:,0:2]]
                img = Image.new('L', (volunteer["columns"], volunteer["rows"]), 0)
                if(len(poly2)>1):
                    ImageDraw.Draw(img).polygon(poly2, outline=1, fill=1)
                mask2 = np.array(img)
                im_array = 2*mask.astype(np.int32)-mask2
                im = Image.fromarray(im_array, 'I')
                im.save('{}/{}_slice{:03d}_frame{:03d}-mask.png'.format(output_folder,volunteerId,z,t))
