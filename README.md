# BSGenome custom references

Repository of scripts and seed files used to generate custom 
[BSGenome](https://bioconductor.org/packages/release/bioc/html/BSgenome.html)
packages.

## Usage

1. For each genome, there is a subdirectory `<REFNAME>`.

2. Check the seed file to determine where to download the source data and update
   the `seqs_srcdir:` attribute to be the absolute path to the directory where
   you downloaded the source data file(s).

3 In each subdirectory, there is a `<REFNAME>_forge.sh` script. Running this
   script will build and install the package.
   
For more inforamtion on how this works, see the
[`BSGenomeForge` documentation](https://www.bioconductor.org/packages/devel/bioc/vignettes/BSgenome/inst/doc/BSgenomeForge.pdf).
