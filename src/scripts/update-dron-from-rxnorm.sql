PRAGMA foreign_keys = ON;

ATTACH 'tmp/dron.db' AS dron;
ATTACH 'tmp/chebi.db' AS chebi;
ATTACH 'tmp/rxnorm.db' AS rxnorm;

.headers on

-- Find new clinical drug forms.
DROP TABLE IF EXISTS new_clinical_drug_form;
CREATE TABLE new_clinical_drug_form AS
SELECT
  c.RXCUI AS rxcui,
  c.STR AS label,
  COALESCE(df.curie, 'DRON:00000005') AS parent -- default 'drug product'
FROM rxnorm.RXNCONSO AS c
LEFT JOIN rxnorm.RXNREL AS r ON r.RXCUI2 = c.RXCUI
JOIN dron.dose_form AS df ON r.RXCUI1 = df.rxcui
WHERE c.SAB = 'RXNORM'
  AND c.TTY = 'SCDF'
  AND c.RXCUI NOT IN (SELECT rxcui FROM dron.clinical_drug_form)
  AND r.RELA = 'has_dose_form';

-- Find new clinical drugs.
DROP TABLE IF EXISTS new_clinical_drug;
CREATE TABLE new_clinical_drug AS
SELECT
  RXCUI AS rxcui,
  STR AS label
FROM rxnorm.RXNCONSO
WHERE SAB = 'RXNORM'
  AND TTY = 'SCD'
  AND RXCUI NOT IN (SELECT rxcui FROM dron.clinical_drug);

-- Find new branded drugs.
DROP TABLE IF EXISTS new_branded_drug;
CREATE TABLE new_branded_drug AS
SELECT
  RXCUI AS rxcui,
  STR AS label
FROM rxnorm.RXNCONSO
WHERE SAB = 'RXNORM'
  AND TTY = 'SBD'
  AND RXCUI NOT IN (SELECT rxcui FROM dron.branded_drug);

-- Collect a list of new ingredients.
DROP TABLE IF EXISTS new_ingredient;
CREATE TABLE new_ingredient (
  rxcui INTEGER PRIMARY KEY,
  label TEXT
);

-- Find new ingredients for new clinical drug forms.
-- We join the RXNREL table
-- where the relation is 'has_ingredient'
-- the RXCUI1 is the ingredient
-- and the RXCUI2 is the clinical drug form.
INSERT OR IGNORE INTO new_ingredient
SELECT DISTINCT
    c.RXCUI AS rxcui,
    c.STR AS label
FROM new_clinical_drug_form AS cdf
LEFT JOIN rxnorm.RXNREL AS r ON r.RXCUI2 = cdf.rxcui
LEFT JOIN rxnorm.RXNCONSO AS c ON c.RXCUI = r.RXCUI1
WHERE r.RELA = 'has_ingredient'
  AND c.SAB = 'RXNORM'
  AND c.RXCUI NOT IN (SELECT rxcui FROM dron.ingredient);

-- Find new ingredients for existing clinical drug forms.
-- Shouldn't happen going forward but needed to fix first time.
-- We join the RXNREL table
-- where the relation is 'has_ingredient'
-- the RXCUI1 is the ingredient
-- and the RXCUI2 is the clinical drug form.
INSERT OR IGNORE INTO new_ingredient
SELECT DISTINCT
    c.RXCUI AS rxcui,
    c.STR AS label
FROM dron.clinical_drug_form AS cdf
LEFT JOIN rxnorm.RXNREL AS r ON r.RXCUI2 = cdf.rxcui
LEFT JOIN rxnorm.RXNCONSO AS c ON c.RXCUI = r.RXCUI1
WHERE r.RELA = 'has_ingredient'
  AND c.SAB = 'RXNORM'
  AND c.RXCUI NOT IN (SELECT rxcui FROM dron.ingredient);

-- Find new ingredients for new branded drug excipients.
-- Link branded drugs to their excipients.
-- Foreach 'has_inactive_ingredient' relation,
-- follow the RXAUI1 atom to an RXCUI for an ingredient
-- and the RXAUI2 atom to an RXCUI for a branded_drug.
INSERT OR IGNORE INTO new_ingredient
SELECT DISTINCT
    c.RXCUI AS rxcui,
    c.STR AS label
FROM rxnorm.RXNREL AS r
LEFT JOIN rxnorm.RXNCONSO AS c1 ON c1.RXAUI = r.RXAUI1
LEFT JOIN rxnorm.RXNCONSO AS c2 ON c2.RXAUI = r.RXAUI2
LEFT JOIN rxnorm.RXNCONSO AS c ON c.RXCUI = c1.RXCUI
WHERE r.RELA = 'has_inactive_ingredient'
  AND c.SAB = 'RXNORM'
  AND c.TTY = 'IN'
  -- AND c.RXCUI NOT IN (SELECT rxcui FROM dron.ingredient)
  AND c2.RXCUI IN (SELECT rxcui FROM dron.branded_drug);

INSERT OR IGNORE INTO rxcui(rxcui)
SELECT rxcui FROM new_ingredient
UNION
SELECT rxcui FROM new_clinical_drug_form
UNION
SELECT rxcui FROM new_clinical_drug
UNION
SELECT rxcui FROM new_branded_drug;

-- Try to find ChEBI terms for new ingredients
INSERT OR IGNORE INTO dron.ingredient
SELECT
    c.subject AS curie,
    c.object AS label,
    i.rxcui AS rxcui
FROM chebi.chebi AS c
JOIN new_ingredient AS i ON i.label = c.object
WHERE c.predicate = 'rdfs:label'
  AND c.subject NOT IN (
    SELECT subject
    FROM chebi.chebi
    WHERE predicate = 'owl:deprecated'
  );

-- Create new DrOn terms for remaining new ingredients
INSERT OR IGNORE INTO dron.ingredient
SELECT
  NULL AS curie,
  label AS label,
  rxcui AS rxcui
FROM new_ingredient
WHERE label NOT IN (SELECT label FROM dron.ingredient)
  AND rxcui NOT IN (SELECT rxcui FROM dron.ingredient);

-- Create new clinical drug forms.
INSERT INTO dron.clinical_drug_form
SELECT
  NULL AS curie,
  label AS label,
  parent AS parent,
  rxcui AS rxcui
FROM new_clinical_drug_form;

-- Link clinical drug forms to their ingredients.
-- We join the RXNREL table
-- where the relation is 'has_ingredient'
-- the RXCUI1 is the ingredient
-- and the RXCUI2 is the clinical drug form.
INSERT OR IGNORE INTO dron.clinical_drug_form_ingredient
SELECT DISTINCT
    cdf.curie AS clinical_drug_form,
    i.curie AS ingredient
FROM dron.clinical_drug_form AS cdf
LEFT JOIN dron.ingredient AS i
LEFT JOIN rxnorm.RXNREL AS r
WHERE cdf.RXCUI IN (SELECT rxcui FROM new_clinical_drug_form)
  AND r.RELA = 'has_ingredient'
  AND i.rxcui = r.RXCUI1
  AND cdf.rxcui = r.RXCUI2;

-- Create new clinical drugs,
-- and link them to their clinical drug form parents.
INSERT INTO dron.clinical_drug
SELECT DISTINCT
    NULL AS curie,
    c.STR AS label,
    cdf.curie AS clinical_drug_form,
    c.RXCUI AS rxcui
FROM rxnorm.RXNCONSO AS c
JOIN rxnorm.RXNREL AS r
  ON c.RXCUI = r.RXCUI2
JOIN dron.clinical_drug_form AS cdf
  ON r.RXCUI1 = cdf.rxcui
WHERE c.RXCUI IN (SELECT rxcui FROM new_clinical_drug)
  AND c.SAB = 'RXNORM'
  AND c.TTY = 'SCD'
  AND r.RELA = 'isa';

-- Link clinical drugs to their ingredients and strengths.
-- Foreach clinical_drug, find its SCDC consituents.
-- Foreach constituent,
-- get its has_ingrediant relation,
-- and its RXN_STRENGTH attribute.
INSERT OR IGNORE INTO dron.clinical_drug_strength
SELECT DISTINCT
  cd.curie AS clinical_drug,
  i.curie AS ingredient,
  SUBSTR(s.ATV, 1, INSTR(s.ATV, ' ') - 1) AS strength,
  u.curie AS unit
FROM dron.clinical_drug AS cd
LEFT JOIN dron.ingredient AS i
LEFT JOIN rxnorm.RXNCONSO AS c
LEFT JOIN rxnorm.RXNREL AS r1
LEFT JOIN rxnorm.RXNREL AS r2
LEFT JOIN rxnorm.RXNSAT AS s
LEFT JOIN dron.unit AS u
WHERE cd.rxcui IN (SELECT rxcui FROM new_clinical_drug)
  AND r1.RXCUI1 = cd.rxcui
  AND r1.RELA = 'constitutes'
  AND c.RXCUI = r1.RXCUI2
  AND c.SAB = 'RXNORM'
  AND c.TTY = 'SCDC'
  AND r2.RXCUI2 = c.RXCUI
  AND r2.RELA = 'has_ingredient'
  AND i.rxcui = r2.RXCUI1
  AND s.RXCUI = c.RXCUI
  AND s.SAB = 'RXNORM'
  AND s.ATN = 'RXN_STRENGTH'
  AND SUBSTR(s.ATV, INSTR(s.ATV, ' ') + 1) = u.label;

-- Create new branded drugs
-- and link them to their clinical drugs.
-- We join the RXNREL table
-- where the relation is 'tradename_of'
-- the RXCUI1 is the clinical drug
-- and the RXCUI2 is the branded drug.
INSERT OR IGNORE INTO dron.branded_drug
SELECT DISTINCT
    NULL AS curie,
    c.STR AS label,
    cd.curie AS clinical_drug,
    c.RXCUI AS rxcui
FROM rxnorm.RXNCONSO AS c
LEFT JOIN rxnorm.RXNREL AS r
  ON c.RXCUI = r.RXCUI2
LEFT JOIN dron.clinical_drug AS cd
  ON r.RXCUI1 = cd.rxcui
LEFT JOIN dron.branded_drug AS bd
  ON r.RXCUI2 = bd.rxcui
WHERE c.RXCUI IN (SELECT rxcui FROM new_branded_drug)
  AND c.SAB = 'RXNORM'
  AND c.TTY = 'SBD'
  AND r.RELA = 'tradename_of'
  AND bd.curie IS NULL;

-- Link branded drugs to their excipients.
-- Foreach 'has_inactive_ingredient' relation,
-- follow the RXAUI1 atom to an RXCUI for an ingredient
-- and the RXAUI2 atom to an RXCUI for a branded_drug.
INSERT OR IGNORE INTO dron.branded_drug_excipient
SELECT DISTINCT
    bd.curie AS branded_drug,
    i.curie AS ingredient
FROM rxnorm.RXNREL AS r
LEFT JOIN dron.branded_drug AS bd
LEFT JOIN dron.ingredient AS i
LEFT JOIN rxnorm.RXNCONSO AS c1
LEFT JOIN rxnorm.RXNCONSO AS c2
WHERE r.RELA = 'has_inactive_ingredient'
  AND c1.RXAUI = r.RXAUI1
  AND c1.RXCUI = i.rxcui
  AND c2.RXAUI = r.RXAUI2
  AND c2.RXCUI = bd.rxcui;

-- Add NDCs for branded drugs not already in ndc_branded_drug or ndc_clinical_drug.
--  Note that by starting with branded drugs, we prefer branded drug association 
--   in hte event that an NDC is associated with both a branded & a clinical drug.
INSERT OR IGNORE INTO ndc_branded_drug
SELECT DISTINCT
    NULL AS curie,
    s.ATV AS ndc,
    bd.curie AS drug
FROM rxnorm.RXNSAT AS s
LEFT JOIN branded_drug AS bd
LEFT JOIN ndc_branded_drug AS n
  ON s.ATV = n.ndc
WHERE s.RXCUI = bd.rxcui
  AND s.SAB = 'RXNORM'
  AND s.ATN = 'NDC'
  AND n.curie IS NULL
  AND s.ATV not in (select ndc from ndc_clinical_drug);

-- Add NDCs for clinical drugs not already in ndc_clinical_drug or ndc_branded_drug.
INSERT OR IGNORE INTO ndc_clinical_drug
SELECT DISTINCT
    NULL AS curie,
    s.ATV AS ndc,
    cd.curie AS drug
FROM rxnorm.RXNSAT AS s
LEFT JOIN clinical_drug AS cd
LEFT JOIN ndc_clinical_drug AS n
  ON s.ATV = n.ndc
WHERE s.RXCUI = cd.rxcui
  AND s.SAB = 'RXNORM'
  AND s.ATN = 'NDC'
  AND n.curie IS NULL
  AND s.ATV not in (select ndc from ndc_branded_drug);

-- In the event that there is an NDC in ndc_clinical_drug, and that is now--
--  in the current version of RxNorm that we are processing--
--  associated with a branded drug, then we will isnert a row in 
--  ndc_branded_drug for this new association. Later, we will deal 
--  with the redundancy.
INSERT INTO ndc_branded_drug
SELECT DISTINCT
    n.curie as curie,
    n.ndc as ndc,
    bd.curie as drug
FROM rxnorm.RXNSAT as s, 
     branded_drug as bd, 
     ndc_clinical_drug AS n
 WHERE s.ATV = n.ndc
   AND s.RXCUI = bd.RXCUI
   AND s.SAB = 'RXNORM'
   AND s.ATN = 'NDC';

-- Here, we delete anything that got duplicated in the previous step.
-- If we updated the NDC to a new branded_drug association, then 
--  we created a new row in ndc_branded_drug, and to avoid duplicawtion
--  now here will remove all such dups from ndc_clinical_drug
DELETE from ndc_clinical_drug
WHERE ndc in (select ndc from ndc_branded_drug); 
