-- Collect labels from ChEBI terms that are not deprecated.
DROP TABLE IF EXISTS label;
CREATE TABLE label (
    curie TEXT PRIMARY KEY,
    label TEXT UNIQUE
);

INSERT OR IGNORE INTO label
SELECT
  subject AS curie,
  object AS label
FROM chebi
WHERE predicate = 'rdfs:label'
  AND subject NOT IN (
    SELECT subject
    FROM chebi
    WHERE predicate = 'owl:deprecated'
  );
CREATE INDEX idx_label_label ON label(label);
ANALYZE label;
