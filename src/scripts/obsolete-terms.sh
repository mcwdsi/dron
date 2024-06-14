#!/bin/sh
#
# Obsolete a DRON term and replace it with another term.

fail() {
  echo "ERROR: " "$@"
  exit 1
}

ROOT=$(git rev-parse --show-toplevel) || fail "Not a git repository"
DIR="${ROOT}/src/ontology"
SCRIPTSDIR="${ROOT}/src/scripts"
TEMPLATEDIR="${ROOT}/src/templates"
DB="${DIR}/tmp/dron.db"

# Replace one term ID with another ID throughout.
replace() {
  OBSOLETE="$1"
  REPLACEMENT="$2"
  if [ -n "${REPLACEMENT}" ]; then
    < "${SCRIPTSDIR}/obsolete-terms.sql" \
      sed "s/OBSOLETE/${OBSOLETE}/g" \
    | sed "s/REPLACEMENT/${REPLACEMENT}/g" \
    | sqlite3 "${DB}" \
    || fail "Could not obsolete ${OBSOLETE}"
  fi
}

# Load template TSVs into SQLite.
cd "${DIR}" || fail "Could not cd to ${DIR}"
make tmp/dron.db || fail "Could not make ${DB}"

# Iterate over the rows of obsolete.tsv and replace.
tail -n+2 "${TEMPLATEDIR}/obsolete.tsv" \
| cut -f1,4 \
| while read -r p; do
  replace $p
done

# Save templates TSVs.
cd "${TEMPLATEDIR}" \
&& sqlite3 "${DB}" < "${SCRIPTSDIR}/save-dron-tables.sql" \
|| fail "Could not save updated templates"
