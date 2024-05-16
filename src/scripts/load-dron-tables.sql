-- Load the DrOn tables.

PRAGMA foreign_keys = ON;

.headers on
.mode tabs

.import --skip 1 ../templates/rxcui.tsv rxcui
.import --skip 1 ../templates/disposition.tsv disposition
.import --skip 1 ../templates/ingredient.tsv ingredient
.import --skip 1 ../templates/ingredient_disposition.tsv ingredient_disposition
.import --skip 1 ../templates/clinical_drug_form.tsv clinical_drug_form
.import --skip 1 ../templates/clinical_drug_form_ingredient.tsv clinical_drug_form_ingredient
.import --skip 1 ../templates/clinical_drug_form_disposition.tsv clinical_drug_form_disposition
.import --skip 1 ../templates/clinical_drug.tsv clinical_drug
.import --skip 1 ../templates/clinical_drug_strength.tsv clinical_drug_strength
.import --skip 1 ../templates/branded_drug.tsv branded_drug
.import --skip 1 ../templates/branded_drug_excipient.tsv branded_drug_excipient
.import --skip 1 ../templates/ndc_branded_drug.tsv ndc_branded_drug
.import --skip 1 ../templates/ndc_clinical_drug.tsv ndc_clinical_drug
