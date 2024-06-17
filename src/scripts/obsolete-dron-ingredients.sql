-- Add DRON ingredients to obsolete.tsv
-- if they match ChEBI labels.

ATTACH 'tmp/dron.db' AS dron;
ATTACH 'tmp/chebi.db' AS chebi;

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
INSERT OR IGNORE INTO dron.obsolete
SELECT
    i.curie AS curie,
    'obsolete ' || i.label AS label,
    'owl:Class' AS type,
    l.subject AS replaced_by
FROM dron.ingredient AS i
JOIN labels AS l ON l.label = i.label
WHERE i.curie LIKE 'DRON:%';
