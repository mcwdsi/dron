#!/bin/sh
#
# Add DRON ingredients to obsolete.tsv
# if they match ChEBI labels.

fail() {
  echo "ERROR: " "$@"
  exit 1
}

ROOT=$(git rev-parse --show-toplevel) || fail "Not a git repository"
DIR="${ROOT}/src/ontology"
SCRIPTSDIR="${ROOT}/src/scripts"
TEMPLATEDIR="${ROOT}/src/templates"
DB="${DIR}/tmp/dron.db"

# Load template TSVs into SQLite.
cd "${DIR}" || fail "Could not cd to ${DIR}"
make tmp/dron.db || fail "Could not make tmp/dron.db"
make tmp/chebi.db || fail "Could not make tmp/chebi.db"

# Find DRON ingredients matching ChEBI labels.
sqlite3 "${DB}" < "${SCRIPTSDIR}/obsolete-dron-ingredients.sql" \
|| fail "Could not run query for ingredients"

# Save obsolete.tsv.
cd "${TEMPLATEDIR}" \
&& sqlite3 "${DB}" < "${SCRIPTSDIR}/save-dron-tables.sql" \
|| fail "Could not save updated obsolete.tsv"
