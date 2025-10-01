# Ependymoma single-cell analysis
Reanalysis of single-cell data published in [Gojo et al., 2020, "Single-Cell RNA-Seq Reveals Cellular Hierarchies and Impaired Developmental Trajectories in Pediatric Ependymoma"](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7479515/)  

## Data
Download the data from GEO ID [GSE141460](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE141460):
```
data
└── external
    └── gojo_et_al
        ├── Matched_pair_counts_200519lj.txt
        ├── Matched_pair_metadata_200519lj.txt
        ├── PDX_counts.txt
        ├── PDX_metadata.txt
        ├── PF_EPN_counts_200519lj.txt
        ├── PF_EPN_metadata_200519lj.txt
        ├── SP_EPN_counts_200519lj.txt
        ├── SP_EPN_metadata_200519lj.txt
        ├── ST_EPN_counts_200519lj.txt
        └── ST_EPN_metadata_200519lj.txt
```

## Requirements
This project is written in the `R` data science language with the `seurat`, `harmony`, and `jupyter` packages. We recommend installation via conda. For a guide to installing conda, see [this tutorial](https://github.com/auberginekenobi/protocols/tree/main/0_Setting_up_your_workstation).
### Installation instructions
Download this project.
```
git clone git@github.com:auberginekenobi/sc-ependymoma.git
```
Navigate to the root directory for this project.
```
cd ependymoma-single-cell
$EPN_HOME=$(pwd)
```
Install (Mac OS with Apple silicon):
```
CONDA_SUBDIR=osx-64 conda env create -f single-cell.yml
conda activate single-cell
conda config --env --set subdir osx-64
Rscript -e "IRkernel::installspec(name = 'single-cell', displayname = 'single-cell')"
conda deactivate
```
Install (all other operating systems):
```
conda env create -f single-cell.yml
conda activate single-cell
Rscript -e "IRkernel::installspec(name = 'single-cell', displayname = 'single-cell')"
conda deactivate
```
Run the analysis notebook.
```
jupyter lab
```
