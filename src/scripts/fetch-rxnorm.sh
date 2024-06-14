#!/bin/sh

RXNORM=${1:?Please enter an RxNorm_full version: MMDDYYY}
UMLS_APIKEY=${UMLS_APIKEY:-2}
UMLS_APIKEY=${UMLS_APIKEY:?Please provide a UMLS API key https://uts.nlm.nih.gov/uts/edit-profile}

fail() {
  echo "ERROR: $@"
  exit 1
}

ROOT=$(git rev-parse --show-toplevel) || fail "Not a git repository"
DIR="${ROOT}/src/ontology/tmp/rxnorm"
FILE="${DIR}/RxNorm_full_${RXNORM}.zip"

mkdir -p "${DIR}" || fail "Could not create ${DIR}"

echo "Downloading RxNorm_full_${RXNORM}"
curl -L -o "${FILE}" --fail-with-body \
  "https://uts-ws.nlm.nih.gov/download?url=https://download.nlm.nih.gov/umls/kss/rxnorm/RxNorm_full_${RXNORM}.zip&apiKey=${UMLS_APIKEY}" \
  || fail "Could not download ${FILE}"

echo "Extracting RRF files to ${DIR}/"
unzip -j -d "${DIR}" "${FILE}" rrf/* \
  || fail "Could not unzip ${FILE}"
