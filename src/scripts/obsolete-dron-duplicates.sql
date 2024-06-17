-- Add DRON duplicates to obsolete.tsv,
-- with identical 'label' and 'rxcui',
-- keeping the term with the lower ID number.

ATTACH 'tmp/dron.db' AS dron;

DROP TABLE IF EXISTS duplicates_to_keep;
CREATE TABLE duplicates_to_keep (
    curie TEXT PRIMARY KEY,
    label TEXT UNIQUE,
    rxcui INTEGER
);

INSERT OR IGNORE INTO duplicates_to_keep
SELECT
    min(curie) AS curie,
    label AS label,
    rxcui AS rxcui
FROM dron.ingredient
GROUP BY label, rxcui
HAVING COUNT(*) > 1;

INSERT OR IGNORE INTO duplicates_to_keep
SELECT
    min(curie) AS curie,
    label AS label,
    rxcui AS rxcui
FROM dron.clinical_drug_form
GROUP BY label, rxcui
HAVING COUNT(*) > 1;

INSERT OR IGNORE INTO duplicates_to_keep
SELECT
    min(curie) AS curie,
    label AS label,
    rxcui AS rxcui
FROM dron.clinical_drug
GROUP BY label, rxcui
HAVING COUNT(*) > 1;

INSERT OR IGNORE INTO duplicates_to_keep
SELECT
    min(curie) AS curie,
    label AS label,
    rxcui AS rxcui
FROM dron.branded_drug
GROUP BY label, rxcui
HAVING COUNT(*) > 1;

CREATE INDEX idx_duplicate_label ON duplicates_to_keep(label);
CREATE INDEX idx_duplicate_rxcui ON duplicates_to_keep(rxcui);

INSERT OR IGNORE INTO dron.obsolete
SELECT
    i.curie AS curie,
    'obsolete ' || i.label AS label,
    'owl:Class' AS type,
    d.curie AS replaced_by
FROM dron.ingredient AS i
JOIN duplicates_to_keep AS d
WHERE i.label = d.label
  AND i.rxcui = d.rxcui
  AND i.curie NOT IN (SELECT curie FROM duplicates_to_keep);

INSERT OR IGNORE INTO dron.obsolete
SELECT
    i.curie AS curie,
    'obsolete ' || i.label AS label,
    'owl:Class' AS type,
    d.curie AS replaced_by
FROM dron.clinical_drug_form AS i
JOIN duplicates_to_keep AS d
WHERE i.label = d.label
  AND i.rxcui = d.rxcui
  AND i.curie NOT IN (SELECT curie FROM duplicates_to_keep);

INSERT OR IGNORE INTO dron.obsolete
SELECT
    i.curie AS curie,
    'obsolete ' || i.label AS label,
    'owl:Class' AS type,
    d.curie AS replaced_by
FROM dron.clinical_drug AS i
JOIN duplicates_to_keep AS d
WHERE i.label = d.label
  AND i.rxcui = d.rxcui
  AND i.curie NOT IN (SELECT curie FROM duplicates_to_keep);

INSERT OR IGNORE INTO dron.obsolete
SELECT
    i.curie AS curie,
    'obsolete ' || i.label AS label,
    'owl:Class' AS type,
    d.curie AS replaced_by
FROM dron.branded_drug AS i
JOIN duplicates_to_keep AS d
WHERE i.label = d.label
  AND i.rxcui = d.rxcui
  AND i.curie NOT IN (SELECT curie FROM duplicates_to_keep);

DROP TABLE duplicates_to_keep;
