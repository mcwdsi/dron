-- Check for problems with DrOn, ChEBI, and RxNorm.

ATTACH 'tmp/dron.db' AS dron;
ATTACH 'tmp/chebi.db' AS chebi;
ATTACH 'tmp/rxnorm.db' AS rxnorm;

.headers on

-- SELECT
--   i.curie,
--   i.label AS "DrOn label",
--   c.object AS "ChEBI label",
--   i.rxcui,
--   r.STR AS "RxNorm label",
--   LOWER(c.object) = LOWER(r.STR) AS "match"
-- FROM dron.ingredient AS i
-- JOIN chebi.chebi AS c ON c.subject = i.curie
-- JOIN rxnorm.RXNCONSO AS r ON r.RXCUI = i.rxcui
-- WHERE c.predicate = 'rdfs:label'
--   AND r.SAB = 'RXNORM'
--   AND r.TTY = 'IN'
-- LIMIT 10;

-- ingredient

DROP TABLE IF EXISTS problem;
CREATE TABLE problem (
    'table' TEXT,
    'row' TEXT,
    'column' TEXT,
    'level' TEXT,
    'rule' TEXT,
    'message TEXT'
);

INSERT INTO problem
SELECT
    'ingredient',
    rowid,
    'curie',
    'ERROR',
    'CHEBI ID not in ChEBI',
    curie
FROM dron.ingredient
WHERE curie LIKE 'CHEBI:%'
  AND curie NOT IN (SELECT subject FROM chebi.chebi);

INSERT INTO problem
SELECT
    'ingredient',
    i.rowid,
    'curie',
    'WARN',
    'ChEBI term is deprecated',
    i.curie || ' ' || i.label
FROM dron.ingredient AS i
JOIN chebi.chebi AS c ON c.subject = i.curie
WHERE c.predicate = 'owl:deprecated';

CREATE INDEX IF NOT EXISTS dron.idx_ingredient_label ON ingredient(label);
WITH labels AS (
    SELECT subject, object AS label
    FROM chebi.chebi
    WHERE predicate = 'rdfs:label'
      AND subject NOT IN (
        SELECT subject
        FROM chebi.chebi
        WHERE predicate = 'owl:deprecated'
      )
)
INSERT INTO problem
SELECT
    'ingredient',
    i.rowid,
    'label',
    'WARN',
    'DrOn term has matching label in ChEBI',
    i.curie || ' ' || l.subject || ' ' || i.label
FROM dron.ingredient AS i
JOIN labels AS l ON l.label = i.label
WHERE i.curie LIKE 'DRON:%';

INSERT INTO problem
SELECT
    'ingredient',
    rowid,
    'curie',
    'ERROR',
    'duplicate CURIE',
    curie || ' ' || GROUP_CONCAT(label)
FROM dron.ingredient
GROUP BY curie
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'ingredient',
    rowid,
    'label',
    'ERROR',
    'duplicate label',
    GROUP_CONCAT(curie || ' ' || rxcui, '; ') || ': ' || label
FROM dron.ingredient
GROUP BY label
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'ingredient',
    rowid,
    'rxcui',
    'ERROR',
    'duplicate RXCUI',
    rxcui || ' ' || GROUP_CONCAT(curie || ' ' || label, '; ')
FROM dron.ingredient
GROUP BY rxcui
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'ingredient',
    NULL,
    'rxcui',
    'WARN',
    'missing ingredient',
    RXCUI || ' ' || STR
FROM rxnorm.RXNCONSO
WHERE SAB = 'RXNORM'
  AND TTY = 'IN'
  AND RXCUI NOT IN (SELECT rxcui FROM dron.ingredient);

-- clinical_drug_form

INSERT INTO problem
SELECT
    'clinical_drug_form',
    rowid,
    'curie',
    'ERROR',
    'duplicate CURIE',
    curie || ' ' || GROUP_CONCAT(label)
FROM dron.clinical_drug_form
GROUP BY curie
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'clinical_drug_form',
    rowid,
    'label',
    'ERROR',
    'duplicate label',
    GROUP_CONCAT(curie || ' ' || rxcui, '; ') || ': ' || label
FROM dron.clinical_drug_form
GROUP BY label
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'clinical_drug_form',
    rowid,
    'rxcui',
    'ERROR',
    'duplicate RXCUI',
    rxcui || ' ' || GROUP_CONCAT(curie || ' ' || label, '; ')
FROM dron.clinical_drug_form
GROUP BY rxcui
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'clinical_drug_form',
    NULL,
    'rxcui',
    'WARN',
    'missing clinical_drug_form',
    RXCUI || ' ' || STR
FROM rxnorm.RXNCONSO
WHERE SAB = 'RXNORM'
  AND TTY = 'SCDF'
  AND RXCUI NOT IN (SELECT rxcui FROM dron.clinical_drug_form);

-- clinical_drug

INSERT INTO problem
SELECT
    'clinical_drug',
    rowid,
    'curie',
    'ERROR',
    'duplicate CURIE',
    curie || ' ' || GROUP_CONCAT(label)
FROM dron.clinical_drug
GROUP BY curie
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'clinical_drug',
    rowid,
    'label',
    'ERROR',
    'duplicate label',
    GROUP_CONCAT(curie || ' ' || rxcui, '; ') || ': ' || label
FROM dron.clinical_drug
GROUP BY label
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'clinical_drug',
    rowid,
    'rxcui',
    'ERROR',
    'duplicate RXCUI',
    rxcui || ' ' || GROUP_CONCAT(curie || ' ' || label, '; ')
FROM dron.clinical_drug
GROUP BY rxcui
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'clinical_drug',
    NULL,
    'rxcui',
    'WARN',
    'missing clinical_drug',
    RXCUI || ' ' || STR
FROM rxnorm.RXNCONSO
WHERE SAB = 'RXNORM'
  AND TTY = 'SCD'
  AND RXCUI NOT IN (SELECT rxcui FROM dron.clinical_drug);

-- branded_drug

INSERT INTO problem
SELECT
    'branded_drug',
    rowid,
    'curie',
    'ERROR',
    'duplicate CURIE',
    curie || ' ' || GROUP_CONCAT(label)
FROM dron.branded_drug
GROUP BY curie
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'branded_drug',
    rowid,
    'label',
    'ERROR',
    'duplicate label',
    GROUP_CONCAT(curie || ' ' || rxcui, '; ') || ': ' || label
FROM dron.branded_drug
GROUP BY label
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'branded_drug',
    rowid,
    'rxcui',
    'ERROR',
    'duplicate RXCUI',
    rxcui || ' ' || GROUP_CONCAT(curie || ' ' || label, '; ')
FROM dron.branded_drug
GROUP BY rxcui
HAVING COUNT(*) > 1;

INSERT INTO problem
SELECT
    'branded_drug',
    NULL,
    'rxcui',
    'WARN',
    'missing branded_drug',
    RXCUI || ' ' || STR
FROM rxnorm.RXNCONSO
WHERE SAB = 'RXNORM'
  AND TTY = 'SBD'
  AND RXCUI NOT IN (SELECT rxcui FROM dron.branded_drug);

-- Obsolete terms should not be used.

INSERT INTO problem
SELECT
    'disposition',
    rowid,
    'curie',
    'ERROR',
    'obsolete term in use',
    curie || ' ' || label
FROM dron.disposition
WHERE curie IN (SELECT curie FROM dron.obsolete);

INSERT INTO problem
SELECT
    'ingredient',
    rowid,
    'curie',
    'ERROR',
    'obsolete term in use',
    curie || ' ' || label
FROM dron.ingredient
WHERE curie IN (SELECT curie FROM dron.obsolete);

INSERT INTO problem
SELECT
    'clinical_drug_form',
    rowid,
    'curie',
    'ERROR',
    'obsolete term in use',
    curie || ' ' || label
FROM dron.clinical_drug_form
WHERE curie IN (SELECT curie FROM dron.obsolete);

INSERT INTO problem
SELECT
    'clinical_drug',
    rowid,
    'curie',
    'ERROR',
    'obsolete term in use',
    curie || ' ' || label
FROM dron.clinical_drug
WHERE curie IN (SELECT curie FROM dron.obsolete);

INSERT INTO problem
SELECT
    'branded_drug',
    rowid,
    'curie',
    'ERROR',
    'obsolete term in use',
    curie || ' ' || label
FROM dron.branded_drug
WHERE curie IN (SELECT curie FROM dron.obsolete);

INSERT INTO problem
SELECT
    'ndc_clinical_drug',
    rowid,
    'curie',
    'ERROR',
    'obsolete term in use',
    curie || ' NDC ' || ndc
FROM dron.ndc_clinical_drug
WHERE curie IN (SELECT curie FROM dron.obsolete);

INSERT INTO problem
SELECT
    'ndc_branded_drug',
    rowid,
    'curie',
    'ERROR',
    'obsolete term in use',
    curie || ' NDC ' || ndc
FROM dron.ndc_branded_drug
WHERE curie IN (SELECT curie FROM dron.obsolete);
