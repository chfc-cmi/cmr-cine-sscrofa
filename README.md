# Cardiac magnetic resonance CINE images of *Sus scrofa*

This is a data set with end-systolic and end-diastolic CMR CINE images of 11 individual pigs at 4 time points. Some of them received a treatment (induced myocardial infarction), others did not (control). See [`data/metadata/measurements.tsv`](./data/metadata/measurements.tsv).

This is a [DataLad](https://handbook.datalad.org/en/latest/) repository. You can clone the repository with plain `git`, but we recommend using `datalad`. After cloning all data files are just symlinks. In order to get the actual data, download the archive at zenodo: https://doi.org/10.5281/zenodo.7684034, unpack it and add it as a sibling. Then use `datalad get` to get the actual content of the files.

These commands can be used, to clone the latest version from GitHub and add the data from zenodo:
```bash
git clone https://github.com/chfc-cmi/cmr-cine-sscrofa
cd /tmp
wget https://zenodo.org/record/7684034/files/cmr-cine-sscrofa.zip
unzip cmr-cine-sscrofa.zip
cd -
cd cmr-cine-sscrofa
datalad siblings add -s data --url /tmp/cmr-cine-sscrofa
datalad get data
```

## Data

In addition to the MR images manual segmentation of the left ventricle and myocardium are provided.

The raw data is provided in the form of DICOM files and Contour files (format used by Medis).

### Conversion to png

Both images and segmentation masks are also provided in png format with a unified naming scheme.

For reproducibility, the conversion steps are documented below.

#### DICOM to png

DICOM files are converted to png using the program [`code/dcm2pnm`](https://support.dcmtk.org/docs/dcm2pnm.html), the naming of png files is derived from the DICOM folder structure and file names. All steps are bundled in the script [`code/dcm_to_png.sh`](./code/dcm_to_png.sh).

#### Contour to png

The conversion is done in two steps. First the con files are converted to tsv files (and a resolution.tsv file is created with number of columns, rows and slices per measurement). This is done using [`code/con_to_tsv.sh`](./code/con_to_tsv.sh).
Then these tsv files are converted to png (filling implicitly missing slices but not missing timepoints/frames with empty masks) using [`code/tsv_to_png.py`](./code/tsv_to_png.py).

## Usage

This data is used in the [cmr-seg-tl-sscrofa](https://github.com/chfc-cmi/cmr-seg-tl-sscrofa) project to train a deep learning segmentation model.

## Citation

If you use this data, please cite the corresponding publication.
