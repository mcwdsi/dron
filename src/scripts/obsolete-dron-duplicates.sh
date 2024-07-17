#!/bin/sh
#
# Add DRON duplicates to obsolete.tsv,
# keeping the term with the lower ID number.

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

# Find DRON ingredients matching ChEBI labels.
sqlite3 < "${SCRIPTSDIR}/obsolete-dron-duplicates.sql" \
|| fail "Could not run query for duplicates"

# Save obsolete.tsv.
cd "${TEMPLATEDIR}" \
&& sqlite3 "${DB}" < "${SCRIPTSDIR}/save-dron-tables.sql" \
|| fail "Could not save updated obsolete.tsv"
