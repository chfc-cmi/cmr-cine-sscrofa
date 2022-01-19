# Cardiac magnetic resonance CINE images of *Sus scrofa*

This is a data set with CMR CINE images of X individual pigs at 4 time points. Some of them received a treatment (induced myocardial infarction), others did not (control).


## Data

In addition to the MR images manual segmentation of the left ventricle and myocardium are provided.

The raw data is provided in the form of DICOM files and Contour files (format used by Medis).

### Conversion to png

Both images and segmentation masks are also provided in png format with a unified naming scheme.

#### DICOM to png

DICOM files are converted to png using the program `dcm2pnm`, the naming of png files is derived from the DICOM folder structure and file names. All steps are bundled in the script `code/dcm_to_png.sh`
