-- Create the DrOn tables.

CREATE TABLE rxcui (
    rxcui INTEGER PRIMARY KEY NOT NULL,
    replaced_by INTEGER
);

CREATE TABLE disposition (
    curie TEXT PRIMARY KEY,
    label TEXT UNIQUE NOT NULL
);

CREATE TABLE ingredient (
    curie TEXT PRIMARY KEY,
    label TEXT NOT NULL,
    rxcui INTEGER NOT NULL,
    FOREIGN KEY (rxcui) REFERENCES rxcui(rxcui)
);

CREATE TABLE ingredient_disposition (
    ingredient TEXT NOT NULL,
    disposition TEXT NOT NULL,
    FOREIGN KEY (ingredient) REFERENCES ingredient(curie),
    FOREIGN KEY (disposition) REFERENCES disposition(curie)
);

CREATE TABLE clinical_drug_form (
    curie TEXT PRIMARY KEY,
    label TEXT NOT NULL, -- UNIQUE,
    parent TEXT,
    rxcui INTEGER NOT NULL,
    FOREIGN KEY (rxcui) REFERENCES rxcui(rxcui)
);

CREATE TABLE clinical_drug_form_ingredient (
    clinical_drug_form TEXT NOT NULL,
    ingredient TEXT NOT NULL,
    PRIMARY KEY (clinical_drug_form, ingredient),
    FOREIGN KEY (clinical_drug_form) REFERENCES clinical_drug_form(curie),
    FOREIGN KEY (ingredient) REFERENCES ingredient(curie)
);

CREATE TABLE clinical_drug_form_disposition (
    clinical_drug_form TEXT NOT NULL,
    disposition TEXT NOT NULL,
    PRIMARY KEY (clinical_drug_form, disposition),
    FOREIGN KEY (clinical_drug_form) REFERENCES clinical_drug_form(curie),
    FOREIGN KEY (disposition) REFERENCES disposition(curie)
);

CREATE TABLE clinical_drug (
    curie TEXT PRIMARY KEY,
    label TEXT NOT NULL, -- UNIQUE,
    clinical_drug_form TEXT NOT NULL,
    rxcui INTEGER NOT NULL,
    FOREIGN KEY (clinical_drug_form) REFERENCES clinical_drug_form(curie),
    FOREIGN KEY (rxcui) REFERENCES rxcui(rxcui)
);

CREATE TABLE clinical_drug_strength (
    clinical_drug TEXT NOT NULL,
    ingredient TEXT NOT NULL,
    strength TEXT NOT NULL,
    unit TEXT NOT NULL,
    -- WARN: There are some clinical drugs in RxNorm
    -- with the same ingredient but multiple strengths.
    PRIMARY KEY (clinical_drug, ingredient, strength, unit),
    FOREIGN KEY (clinical_drug) REFERENCES clinical_drug(curie),
    FOREIGN KEY (ingredient) REFERENCES ingredient(curie)
);

CREATE TABLE branded_drug (
    curie TEXT PRIMARY KEY,
    label TEXT NOT NULL, -- UNIQUE,
    clinical_drug TEXT NOT NULL,
    rxcui INTEGER NOT NULL,
    FOREIGN KEY (clinical_drug) REFERENCES clinical_drug(curie),
    FOREIGN KEY (rxcui) REFERENCES rxcui(rxcui)
);

CREATE TABLE branded_drug_excipient (
    branded_drug TEXT NOT NULL,
    ingredient TEXT NOT NULL,
    PRIMARY KEY (branded_drug, ingredient),
    FOREIGN KEY (branded_drug) REFERENCES branded_drug(curie),
    FOREIGN KEY (ingredient) REFERENCES ingredient(curie)
);

CREATE TABLE ndc_branded_drug (
    curie TEXT PRIMARY KEY,
    ndc TEXT UNIQUE NOT NULL,
    branded_drug TEXT NOT NULL,
    FOREIGN KEY (branded_drug) REFERENCES branded_drug(curie)
);

CREATE TABLE ndc_clinical_drug (
    curie TEXT PRIMARY KEY,
    ndc TEXT UNIQUE NOT NULL,
    clinical_drug TEXT NOT NULL,
    FOREIGN KEY (clinical_drug) REFERENCES clinical_drug(curie)
);

CREATE TABLE obsolete (
    curie TEXT PRIMARY KEY NOT NULL,
    label TEXT NOT NULL, -- UNIQUE,
    type TEXT NOT NULL,
    replaced_by TEXT
);

CREATE TABLE unit (
    curie TEXT PRIMARY KEY NOT NULL,
    label TEXT UNIQUE NOT NULL,
    ontology_label TEXT UNIQUE NOT NULL
);

CREATE TABLE dose_form (
    rxcui INTEGER PRIMARY KEY NOT NULL,
    label TEXT UNIQUE NOT NULL,
    curie TEXT NOT NULL
);

-- Create triggers for automatically assigning DRON IDs.
-- First create a table with one row to track the current ID.
CREATE TABLE current_dron_id ( id INTEGER );
-- INSERT INTO current_dron_id VALUES (1003000);

-- Then create a trigger for each row where a CURIE can be assigned:
-- When a row is inserted into the table,
-- if the 'curie' is NULL
-- then increment the current_dron_id
-- and use it to generate a new 'DRON:*' ID.
CREATE TRIGGER insert_ingredient_curie
AFTER INSERT ON ingredient
WHEN new.curie IS NULL
BEGIN
    UPDATE current_dron_id SET id = id + 1;
    UPDATE ingredient SET curie = PRINTF('DRON:%08d', (SELECT id FROM current_dron_id LIMIT 1))
    WHERE rowid = new.rowid;
END;

CREATE TRIGGER insert_clinical_drug_form_curie
AFTER INSERT ON clinical_drug_form
WHEN new.curie IS NULL
BEGIN
    UPDATE current_dron_id SET id = id + 1;
    UPDATE clinical_drug_form SET curie = PRINTF('DRON:%08d', (SELECT id FROM current_dron_id LIMIT 1))
    WHERE rowid = new.rowid;
END;

CREATE TRIGGER insert_clinical_drug_curie
AFTER INSERT ON clinical_drug
WHEN new.curie IS NULL
BEGIN
    UPDATE current_dron_id SET id = id + 1;
    UPDATE clinical_drug SET curie = PRINTF('DRON:%08d', (SELECT id FROM current_dron_id LIMIT 1))
    WHERE rowid = new.rowid;
END;

CREATE TRIGGER insert_branded_drug_curie
AFTER INSERT ON branded_drug
WHEN new.curie IS NULL
BEGIN
    UPDATE current_dron_id SET id = id + 1;
    UPDATE branded_drug SET curie = PRINTF('DRON:%08d', (SELECT id FROM current_dron_id LIMIT 1))
    WHERE rowid = new.rowid;
END;

CREATE TRIGGER insert_ndc_branded_drug
AFTER INSERT ON ndc_branded_drug
WHEN new.curie IS NULL
BEGIN
    UPDATE current_dron_id SET id = id + 1;
    UPDATE ndc_branded_drug SET curie = PRINTF('DRON:%08d', (SELECT id FROM current_dron_id LIMIT 1))
    WHERE rowid = new.rowid;
END;

CREATE TRIGGER insert_ndc_clinical_drug
AFTER INSERT ON ndc_clinical_drug
WHEN new.curie IS NULL
BEGIN
    UPDATE current_dron_id SET id = id + 1;
    UPDATE ndc_clinical_drug SET curie = PRINTF('DRON:%08d', (SELECT id FROM current_dron_id LIMIT 1))
    WHERE rowid = new.rowid;
END;
