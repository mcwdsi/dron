-- ### dron-rxnorm

INSERT INTO clinical_drug_form
SELECT
    a.subject AS curie,
    a.object AS label,
    b.object AS parent,
    c.object AS rxcui
FROM dron_rxnorm AS a
LEFT JOIN dron_rxnorm AS b ON a.subject = b.subject
LEFT JOIN dron_rxnorm AS c ON a.subject = c.subject
WHERE a.predicate = 'rdfs:label'
  AND b.predicate = 'rdfs:subClassOf'
  AND c.predicate = 'DRON:00010000'
  AND b.object IN (
    'DRON:00000005', -- drug product
    'DRON:00000015', -- drug gel
    'DRON:00000016', -- drug emulsion
    'DRON:00000017', -- drug cream
    'DRON:00000018', -- drug lotion
    'DRON:00000019', -- drug ointment
    'DRON:00000020', -- drug solution
    'DRON:00000021', -- drug suspension
    'DRON:00000022', -- drug tablet
    'DRON:00000024', -- drug foam
    'DRON:00000026'  -- drug capsule
  )
ORDER BY curie;

INSERT INTO clinical_drug
SELECT
    a.subject AS curie,
    a.object AS label,
    b.object AS clinical_drug_form,
    c.object AS rxcui
FROM dron_rxnorm AS a
LEFT JOIN dron_rxnorm AS b ON a.subject = b.subject
LEFT JOIN dron_rxnorm AS c ON a.subject = c.subject
WHERE a.predicate = 'rdfs:label'
  AND b.predicate = 'rdfs:subClassOf'
  AND b.object IN (SELECT curie FROM clinical_drug_form)
  AND c.predicate = 'DRON:00010000'
ORDER BY curie;

INSERT INTO branded_drug
SELECT
    a.subject AS curie,
    a.object AS label,
    b.object AS clinical_drug,
    c.object AS rxcui
FROM dron_rxnorm AS a
LEFT JOIN dron_rxnorm AS b ON a.subject = b.subject
LEFT JOIN dron_rxnorm AS c ON a.subject = c.subject
WHERE a.predicate = 'rdfs:label'
  AND b.predicate = 'rdfs:subClassOf'
  AND b.object IN (SELECT curie FROM clinical_drug)
  AND c.predicate = 'DRON:00010000'
ORDER BY curie;

INSERT INTO clinical_drug_form_disposition
SELECT
    subject AS clinical_drug_form,
    json_extract(object, '$.owl:someValuesFrom[0].object') AS disposition
FROM dron_rxnorm
WHERE predicate = 'rdfs:subClassOf'
  AND datatype = '_JSON';


-- ### dron-ingredient

INSERT OR IGNORE INTO ingredient
SELECT
    a.subject AS curie,
    a.object AS label,
    b.object AS rxcui
FROM dron_ingredient AS a
LEFT JOIN dron_ingredient AS b
WHERE a.predicate = 'rdfs:label'
  AND b.predicate = 'DRON:00010000'
  AND a.subject = b.subject
ORDER BY a.subject;

INSERT INTO disposition
SELECT
    a.subject AS curie,
    b.object AS label
FROM dron_ingredient AS a
LEFT JOIN dron_ingredient AS b
WHERE a.predicate = 'rdfs:subClassOf'
  AND a.object = 'BFO:0000016'
  AND a.subject = b.subject
  AND b.predicate = 'rdfs:label'
ORDER BY a.subject;

INSERT INTO ingredient_disposition
SELECT
    subject AS ingredient,
    json_extract(object, '$.owl:someValuesFrom[0].object') AS disposition
FROM dron_ingredient
WHERE subject IN (SELECT curie FROM ingredient)
  AND predicate = 'rdfs:subClassOf'
  AND datatype = '_JSON'
ORDER BY subject;

INSERT INTO clinical_drug_form_ingredient
SELECT
    subject AS clinical_drug_form,
    json_extract(object, '$.owl:someValuesFrom[0].object.owl:intersectionOf[0].object.rdf:rest[0].object.rdf:rest[0].object.rdf:first[0].object.owl:someValuesFrom[0].object') AS ingredient
FROM dron_ingredient
WHERE subject IN (SELECT curie FROM clinical_drug_form)
  AND predicate = 'rdfs:subClassOf'
  AND datatype = '_JSON'
ORDER BY subject;

INSERT INTO clinical_drug_strength
SELECT
    subject AS clinical_drug,
    json_extract(object, '$.owl:someValuesFrom[0].object.owl:intersectionOf[0].object.rdf:rest[0].object.rdf:rest[0].object.rdf:rest[0].object.rdf:first[0].object.owl:someValuesFrom[0].object') AS ingredient,
    json_extract(object, '$.owl:someValuesFrom[0].object.owl:intersectionOf[0].object.rdf:rest[0].object.rdf:rest[0].object.rdf:first[0].object.owl:someValuesFrom[0].object.owl:intersectionOf[0].object.rdf:rest[0].object.rdf:rest[0].object.rdf:first[0].object.owl:hasValue[0].object') AS strength,
    json_extract(object, '$.owl:someValuesFrom[0].object.owl:intersectionOf[0].object.rdf:rest[0].object.rdf:rest[0].object.rdf:first[0].object.owl:someValuesFrom[0].object.owl:intersectionOf[0].object.rdf:rest[0].object.rdf:first[0].object.owl:hasValue[0].object') AS unit
FROM dron_ingredient
WHERE subject IN (SELECT curie FROM clinical_drug)
  AND predicate = 'rdfs:subClassOf'
  AND datatype = '_JSON'
ORDER BY subject;

INSERT INTO branded_drug_excipient
SELECT
    subject AS branded_drug,
    json_extract(object, '$.owl:someValuesFrom[0].object.owl:intersectionOf[0].object.rdf:rest[0].object.rdf:rest[0].object.rdf:first[0].object.owl:someValuesFrom[0].object') AS ingredient
FROM dron_ingredient
WHERE subject IN (SELECT curie FROM branded_drug)
  AND predicate = 'rdfs:subClassOf'
  AND datatype = '_JSON'
ORDER BY subject;


-- ### dron-ndc

INSERT INTO ndc_branded_drug
SELECT
  a.subject AS curie,
  a.object AS ndc,
  json_extract(b.object, '$.owl:someValuesFrom[0].object') AS branded_drug
FROM dron_ndc AS a
LEFT JOIN dron_ndc AS b ON a.subject = b.subject
WHERE a.predicate = 'rdfs:label'
  AND b.predicate = 'rdfs:subClassOf'
  AND b.datatype = '_JSON'
  AND json_extract(b.object, '$.owl:someValuesFrom[0].object') IN (SELECT curie FROM branded_drug)
ORDER BY curie;

INSERT INTO ndc_clinical_drug
SELECT
  a.subject AS curie,
  a.object AS ndc,
  json_extract(b.object, '$.owl:someValuesFrom[0].object') AS clinical_drug
FROM dron_ndc AS a
LEFT JOIN dron_ndc AS b ON a.subject = b.subject
WHERE a.predicate = 'rdfs:label'
  AND b.predicate = 'rdfs:subClassOf'
  AND b.datatype = '_JSON'
  AND json_extract(b.object, '$.owl:someValuesFrom[0].object') IN (SELECT curie FROM clinical_drug)
ORDER BY curie;


-- ### rxcui

INSERT INTO rxcui(rxcui)
SELECT rxcui FROM ingredient
UNION
SELECT rxcui FROM clinical_drug_form
UNION
SELECT rxcui FROM clinical_drug
UNION
SELECT rxcui FROM branded_drug;


-- ## dron-obsolete

INSERT OR IGNORE INTO obsolete(curie, label, type)
SELECT
    a.subject AS curie,
    b.object AS label,
    a.object AS type
FROM dron_obsolete AS a
LEFT JOIN dron_obsolete AS b ON a.subject = b.subject
WHERE a.predicate = 'rdf:type'
  AND b.predicate = 'rdfs:label';

UPDATE obsolete
SET replaced_by = object
FROM dron_obsolete
WHERE obsolete.curie = dron_obsolete.subject
  AND dron_obsolete.predicate = 'IAO:0100001';
