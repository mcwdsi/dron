# Create table from UNII data in sqlite database

CREATE TABLE UNII
(
    unii     		   TEXT PRIMARY KEY,
    display_name       TEXT NOT NULL,
    rn                 TEXT,
    ec                 TEXT,
    ncit               TEXT,
    rxcui              INTEGER,
    pubchem            TEXT,
    smsid              TEXT,
    epa_comptox        TEXT,
    catalogue_of_life  TEXT,
    itis               TEXT,
    ncbi               TEXT,
    plants             TEXT,
    powo               TEXT,
    grin               TEXT,
    mpns               TEXT,
    inn_id             TEXT,
    usan_id            TEXT,
    dailymed           TEXT,
    mf                 TEXT,
    inchikey           TEXT,
    smiles             TEXT,
    ingredient_type    TEXT NOT NULL,
    substance_type     TEXT NOT NULL,
    uuid               TEXT NOT NULL
);
