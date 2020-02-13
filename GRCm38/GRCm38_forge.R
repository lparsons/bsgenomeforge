# Build GRCm38 BSGenome package

if (!require("BSgenome")) install.packages("BSgenome")
forgeBSgenomeDataPkg("/home/lparsons/Documents/projects/bsgenomeforge/GRCm38/BSgenome.Mmusculus.ENSEMBL.GRCm38-seed")
