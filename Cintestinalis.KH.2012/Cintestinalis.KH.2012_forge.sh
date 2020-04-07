#!/usr/bin/env bash
set -euxo pipefail

export REF_NAME="Cintestinalis.KH.2012"
export VERSION="0.1.0"

export PKGDIR="BSgenome.${REF_NAME}"

if ! command -v faToTwoBit >/dev/null 2>&1; then
    echo "Command \"faToTwoBit\" not found, please install UCSC Tools faToTwoBit"
    echo "See https://bioconda.github.io/recipes/ucsc-fatotwobit/README.html"
    exit 1
fi

export DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Make seqs_srcdir
seqs_srcdir="${REF_NAME}_seqs_srcdir"
mkdir -p "${seqs_srcdir}"
export seqs_srcdir="$(readlink -e "${seqs_srcdir}")"

seqs_srcdir_tmp="${seqs_srcdir}_tmp"
mkdir -p "${seqs_srcdir_tmp}"

fasta_file="${REF_NAME}.fa"
fasta_file_tmp="${fasta_file}.tmp"
export seqfile_name="${REF_NAME}.2bit"


cd "${seqs_srcdir_tmp}"

# Get KH 2012 assembly
wget "http://ghost.zool.kyoto-u.ac.jp/datas/JoinedScaffold.zip" --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
unzip "JoinedScaffold.zip"

# Get Ensembl MT sequence
rsync -av "rsync://ftp.ensembl.org/ensembl/pub/release-99/fasta/ciona_intestinalis/dna/Ciona_intestinalis.KH.dna_sm.chromosome.MT.fa.gz" .
gunzip "Ciona_intestinalis.KH.dna_sm.chromosome.MT.fa.gz"

# Combine
cat "JoinedScaffold" "Ciona_intestinalis.KH.dna_sm.chromosome.MT.fa" > "${fasta_file_tmp}"

# Remove KhM0 sequence
echo "KhM0" > "ids.txt"
awk 'BEGIN{while((getline<"ids.txt")>0)l[">"$1]=1}/^>/{f=!l[$1]}f' "${fasta_file_tmp}" > "${fasta_file}"

# Convert to 2bit
cd "${seqs_srcdir}"
faToTwoBit "${seqs_srcdir_tmp}/${fasta_file}" "${seqs_srcdir}/${seqfile_name}"

cd "${DIR}"
echo "Created 2bit file: \"${seqfile_name}\""

# Create seed file
cat "${PKGDIR}-seed.template" | envsubst > "${PKGDIR}-seed"
echo "Created seed file: \"${PKGDIR}-seed\""

# Build package
cat "${REF_NAME}_forge.R.template" | envsubst > "${REF_NAME}_forge.R"
if [[ ! -d "${PKGDIR}" ]]; then
  Rscript "${REF_NAME}_forge.R"
fi

R CMD build "${PKGDIR}"

R CMD check "${PKGDIR}_${VERSION}.tar.gz"

R CMD INSTALL "${PKGDIR}_${VERSION}.tar.gz"

