ATTACH 'tmp/dron.db' AS dron;
ATTACH 'tmp/chebi.db' AS chebi;
ATTACH 'tmp/rxnorm.db' AS rxnorm;

-- Update labels from ChEBI.
UPDATE dron.ingredient AS d
SET label = c.object
FROM chebi.chebi AS c
WHERE d.curie LIKE 'CHEBI:%'
  AND d.curie = c.subject
  AND c.predicate = 'rdfs:label'
  AND d.label != c.object;

-- Update ingredient labels from RxNorm
UPDATE dron.ingredient AS d
SET label = r.STR
FROM rxnorm.RXNCONSO AS r
WHERE d.curie LIKE 'DRON:%'
  AND d.rxcui = r.RXCUI
  AND r.SAB = 'RXNORM'
  AND r.TTY = 'IN';

-- clinical_drug_form
CREATE INDEX IF NOT EXISTS dron.clinical_drug_form_rxcui
  ON clinical_drug_form(rxcui);
UPDATE dron.clinical_drug_form AS d
SET label = r.STR
FROM rxnorm.RXNCONSO AS r
WHERE d.rxcui = r.RXCUI
  AND r.SAB = 'RXNORM'
  AND r.TTY = 'SCDF';

-- clinical_drug
CREATE INDEX IF NOT EXISTS dron.clinical_drug_rxcui
  ON clinical_drug(rxcui);
UPDATE dron.clinical_drug AS d
SET label = r.STR
FROM rxnorm.RXNCONSO AS r
WHERE d.rxcui = r.RXCUI
  AND r.SAB = 'RXNORM'
  AND r.TTY = 'SCD';

-- branded_drug
CREATE INDEX IF NOT EXISTS dron.branded_drug_rxcui
  ON branded_drug(rxcui);
UPDATE dron.branded_drug AS d
SET label = r.STR
FROM rxnorm.RXNCONSO AS r
WHERE d.rxcui = r.RXCUI
  AND r.SAB = 'RXNORM'
  AND r.TTY = 'SBD';
