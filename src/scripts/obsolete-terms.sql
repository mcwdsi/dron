PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- obsolete ingredient

INSERT OR IGNORE INTO ingredient
SELECT
    'REPLACEMENT' AS curie,
    label AS label,
    rxcui AS rxcui
FROM ingredient
WHERE curie = 'OBSOLETE';

UPDATE ingredient_disposition
SET ingredient = 'REPLACEMENT'
WHERE ingredient = 'OBSOLETE';

UPDATE clinical_drug_form_ingredient
SET ingredient = 'REPLACEMENT'
WHERE ingredient = 'OBSOLETE';

UPDATE clinical_drug_strength
SET ingredient = 'REPLACEMENT'
WHERE ingredient = 'OBSOLETE';

UPDATE branded_drug_excipient
SET ingredient = 'REPLACEMENT'
WHERE ingredient = 'OBSOLETE';

DELETE FROM ingredient
WHERE curie = 'OBSOLETE';

-- obsolete clinical_drug_form

INSERT OR IGNORE INTO clinical_drug_form
SELECT
    'REPLACEMENT' AS curie,
    label AS label,
    parent AS parent,
    rxcui AS rxcui
FROM clinical_drug_form
WHERE curie = 'OBSOLETE';

UPDATE clinical_drug_form_ingredient
SET clinical_drug_form = 'REPLACEMENT'
WHERE clinical_drug_form = 'OBSOLETE';

UPDATE clinical_drug_form_disposition
SET clinical_drug_form = 'REPLACEMENT'
WHERE clinical_drug_form = 'OBSOLETE';

UPDATE clinical_drug
SET clinical_drug_form = 'REPLACEMENT'
WHERE clinical_drug_form = 'OBSOLETE';

DELETE FROM clinical_drug_form
WHERE curie = 'OBSOLETE';

-- obsolete clinical_drug

INSERT OR IGNORE INTO clinical_drug
SELECT
    'REPLACEMENT' AS curie,
    label AS label,
    clinical_drug_form AS clinical_drug_form,
    rxcui AS rxcui
FROM clinical_drug
WHERE curie = 'OBSOLETE';

UPDATE clinical_drug_strength
SET clinical_drug = 'REPLACEMENT'
WHERE clinical_drug = 'OBSOLETE';

UPDATE branded_drug
SET clinical_drug = 'REPLACEMENT'
WHERE clinical_drug = 'OBSOLETE';

UPDATE ndc_clinical_drug
SET clinical_drug = 'REPLACEMENT'
WHERE clinical_drug = 'OBSOLETE';

DELETE FROM clinical_drug
WHERE curie = 'OBSOLETE';

-- obsolete branded_drug

INSERT OR IGNORE INTO branded_drug
SELECT
    'REPLACEMENT' AS curie,
    label AS label,
    clinical_drug AS clinical_drug,
    rxcui AS rxcui
FROM branded_drug
WHERE curie = 'OBSOLETE';

UPDATE branded_drug_excipient
SET branded_drug = 'REPLACEMENT'
WHERE branded_drug = 'OBSOLETE';

UPDATE ndc_branded_drug
SET branded_drug = 'REPLACEMENT'
WHERE branded_drug = 'OBSOLETE';

DELETE FROM branded_drug
WHERE curie = 'OBSOLETE';

-- done

COMMIT;
