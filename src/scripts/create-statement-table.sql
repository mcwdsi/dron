DROP TABLE IF EXISTS statement;
CREATE TABLE statement (
    assertion INTEGER NOT NULL DEFAULT 1,
    retraction INTEGER NOT NULL DEFAULT 0,
    graph TEXT NOT NULL DEFAULT 'graph',
    subject TEXT NOT NULL,
    predicate TEXT NOT NULL,
    object TEXT NOT NULL,
    datatype TEXT NOT NULL DEFAULT '_IRI',
    annotation TEXT DEFAULT NULL
);
