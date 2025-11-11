-- Add DRON ingredients to obsolete.tsv
-- if they match ChEBI labels.

ATTACH 'tmp/dron.db' AS dron;
ATTACH 'tmp/chebi.db' AS chebi;

CREATE INDEX IF NOT EXISTS dron.idx_ingredient_label ON ingredient(label);
INSERT OR IGNORE INTO dron.obsolete
SELECT
    i.curie AS curie,
    'obsolete ' || i.label AS label,
    'owl:Class' AS type,
    c.curie AS replaced_by
FROM dron.ingredient AS i
JOIN chebi.label AS c ON c.label = i.label COLLATE NOCASE
WHERE i.curie LIKE 'DRON:%';
