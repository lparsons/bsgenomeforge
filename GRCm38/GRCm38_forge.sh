#!/usr/bin/env bash
set -euxo pipefail

PKGDIR="BSgenome.Mmusculus.ENSEMBL.GRCm38"
VERSION="0.1.0"

if [[ ! -d "${PKGDIR}" ]]; then
  Rscript GRCm38_forge.R
fi

R CMD build "${PKGDIR}"

R CMD check "${PKGDIR}_${VERSION}.tar.gz"

R CMD INSTALL "${PKGDIR}_${VERSION}.tar.gz"
