# Cardiac magnetic resonance CINE images of *Sus scrofa*

This is a data set with CMR CINE images of X individual pigs at 4 time points. Some of them received a treatment (induced myocardial infarction), others did not (control).


## Data

In addition to the MR images manual segmentation of the left ventricle and myocardium are provided.

The raw data is provided in the form of DICOM files and Contour files (format used by Medis).

### Conversion to png

Both images and segmentation masks are also provided in png format with a unified naming scheme.

#### DICOM to png

DICOM files are converted to png using the program `dcm2pnm`, the naming of png files is derived from the DICOM folder structure and file names. All steps are bundled in the script `code/dcm_to_png.sh`

#### Contour to png

The conversion is done in two steps. First the con files are converted to tsv files (and a resolution.tsv file is created with number of columns, rows and slices per measurement). This is done using `code/con_to_tsv.sh`.
Then these tsv files are converted to png (filling implicitly missing slices but not missing timepoints/frames with empty masks).

### Quality control

A check that the number of slices per measurement are the same for the images as the masks revealed the following inconsistencies:

```zsh
paste data/intermediate/masks/obs0_rep0/resolution.tsv <(echo image_slices;ls data/png/images/A*_slice0*_frame000* | cut -f1 -d "_" | cut -f4 -d"/" | uniq -c) | awk '$4 != $5'
# id	columns	rows	slices	image_slices
# A12	800	752	13	     12 A12
# A29	752	800	16	     14 A29
# A31	540	576	9	     11 A31
# A43	752	800	12	     13 A43
```

This needs to be checked and corrected.

Checking the repeated labels from observer 0 shows discrepancies:

```zsh
diff data/intermediate/masks/obs0_rep[01]/resolution.tsv
# 2c2,4
# < A05	752	800	11
# ---
# > A03	540	576	13
# > A04	540	576	12
# > A05	540	576	11
# 9a12
# > A14	540	576	15
```

So the masks for A05 have the wrong resolution in the repeat and A03, A04, and A14 have not previously been labeled (and the images are not included).
