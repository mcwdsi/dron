#!/bin/sh


ROOT=$(git rev-parse --show-toplevel) || fail "Not a git repository"
DIR="${ROOT}/src/ontology/tmp/unii"
FILE="${DIR}/UNII_Data.zip"

mkdir -p "${DIR}" || fail "Could not create ${DIR}"

echo "Downloading UNII_Data.zip"
curl -L -o "${FILE}" --fail-with-body \
  "https://precision.fda.gov/uniisearch/archive/latest/UNII_Data.zip" \
  || fail "Could not download ${FILE}"

echo "Extracting file to ${DIR}/"
unzip -j -o -d "${DIR}" "${FILE}"  \
  || fail "Could not unzip ${FILE}"

# Finds the most recent file matching 'pattern*' and renames it to 'new_name'
cp "$(ls -t ${DIR}/UNII_Records* | head -1)" ${DIR}/UNII_Records_Latest.txt


# Mark files as new.
touch "${DIR}/*"
