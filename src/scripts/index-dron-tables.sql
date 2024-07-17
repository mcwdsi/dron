-- Index main DrOn tables.

CREATE INDEX IF NOT EXISTS idx_ingredient_curie ON ingredient(curie);
CREATE INDEX IF NOT EXISTS idx_ingredient_label ON ingredient(label);
CREATE INDEX IF NOT EXISTS idx_ingredient_rxcui ON ingredient(rxcui);

CREATE INDEX IF NOT EXISTS idx_clinical_drug_form_curie ON clinical_drug_form(curie);
CREATE INDEX IF NOT EXISTS idx_clinical_drug_form_label ON clinical_drug_form(label);
CREATE INDEX IF NOT EXISTS idx_clinical_drug_form_rxcui ON clinical_drug_form(rxcui);

CREATE INDEX IF NOT EXISTS idx_clinical_drug_form_ingredient_clinical_drug_form ON clinical_drug_form_ingredient(clinical_drug_form);
CREATE INDEX IF NOT EXISTS idx_clinical_drug_form_ingredient_ingredient ON clinical_drug_form_ingredient(ingredient);

CREATE INDEX IF NOT EXISTS idx_clinical_drug_curie ON clinical_drug(curie);
CREATE INDEX IF NOT EXISTS idx_clinical_drug_label ON clinical_drug(label);
CREATE INDEX IF NOT EXISTS idx_clinical_drug_rxcui ON clinical_drug(rxcui);

CREATE INDEX IF NOT EXISTS idx_clinical_drug_strength_clinical_drug ON clinical_drug_strength(clinical_drug);
CREATE INDEX IF NOT EXISTS idx_clinical_drug_strength_ingredient ON clinical_drug_strength(ingredient);

CREATE INDEX IF NOT EXISTS idx_branded_drug_curie ON branded_drug(curie);
CREATE INDEX IF NOT EXISTS idx_branded_drug_label ON branded_drug(label);
CREATE INDEX IF NOT EXISTS idx_branded_drug_rxcui ON branded_drug(rxcui);

CREATE INDEX IF NOT EXISTS idx_branded_drug_excipient_branded_drug ON branded_drug_excipient(branded_drug);
CREATE INDEX IF NOT EXISTS idx_branded_drug_excipient_ingredient ON branded_drug_excipient(ingredient);

CREATE INDEX IF NOT EXISTS idx_ndc_clinical_drug_curie ON ndc_clinical_drug(curie);
CREATE INDEX IF NOT EXISTS idx_ndc_clinical_drug_ndc ON ndc_clinical_drug(ndc);
CREATE INDEX IF NOT EXISTS idx_ndc_clinical_drug_clinical_drug ON ndc_clinical_drug(clinical_drug);

CREATE INDEX IF NOT EXISTS idx_ndc_branded_drug_curie ON ndc_branded_drug(curie);
CREATE INDEX IF NOT EXISTS idx_ndc_branded_drug_ndc ON ndc_branded_drug(ndc);
CREATE INDEX IF NOT EXISTS idx_ndc_branded_drug_branded_drug ON ndc_branded_drug(branded_drug);

ANALYZE;
