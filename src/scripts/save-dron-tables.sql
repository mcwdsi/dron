-- Save the DrOn tables.
.headers on
.mode tabs

.output rxcui.tsv
SELECT * FROM rxcui ORDER BY rxcui;

.output disposition.tsv
SELECT * FROM disposition ORDER BY curie;

.output ingredient.tsv
SELECT * FROM ingredient ORDER BY curie;

.output ingredient_disposition.tsv
SELECT * FROM ingredient_disposition ORDER BY ingredient, disposition;

.output clinical_drug_form.tsv
SELECT * FROM clinical_drug_form ORDER BY curie;

.output clinical_drug_form_ingredient.tsv
SELECT * FROM clinical_drug_form_ingredient ORDER BY clinical_drug_form, ingredient;

.output clinical_drug_form_disposition.tsv
SELECT * FROM clinical_drug_form_disposition ORDER BY clinical_drug_form, disposition;

.output clinical_drug.tsv
SELECT * FROM clinical_drug ORDER BY curie;

.output clinical_drug_strength.tsv
SELECT * FROM clinical_drug_strength ORDER BY clinical_drug, ingredient, strength;

.output branded_drug.tsv
SELECT * FROM branded_drug ORDER BY curie;

.output branded_drug_excipient.tsv
SELECT * FROM branded_drug_excipient ORDER BY branded_drug, ingredient;

.output ndc_branded_drug.tsv
SELECT * FROM ndc_branded_drug ORDER BY curie;

.output ndc_clinical_drug.tsv
SELECT * FROM ndc_clinical_drug ORDER BY curie;
