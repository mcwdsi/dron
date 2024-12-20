ATTACH DATABASE 'tmp/dron.db' AS dron;

-- ### Ingredients

-- Add some top-level terms.
INSERT INTO dron_ingredient(subject, predicate, object) VALUES
('obo:dron/dron-ingredient.owl', 'rdf:type', 'owl:Ontology'),
('<http://www.obofoundry.org/ro/ro.owl#has_proper_part>', 'rdf:type', 'owl:ObjectProperty'),
('BFO:0000016', 'rdf:type', 'owl:Class'),
('RO:0000053', 'rdf:type', 'owl:ObjectProperty'),
('BFO:0000071', 'rdf:type', 'owl:ObjectProperty'),
('IAO:0000039', 'rdf:type', 'owl:ObjectProperty'),
('OBI:0000047', 'rdf:type', 'owl:Class'),
('OBI:0000576', 'rdf:type', 'owl:Class'),
('OBI:0001937', 'rdf:type', 'owl:DatatypeProperty'),
('PATO:0000125', 'rdf:type', 'owl:Class'),
('UO:0000022', 'rdf:type', 'owl:NamedIndividual'),
('DRON:00000028', 'rdf:type', 'owl:Class'),
('DRON:00000029', 'rdf:type', 'owl:Class'),
('DRON:00010000', 'rdf:type', 'owl:AnnotationProperty');

-- Add some duplicate CHEBI annotations.
-- TODO: Clean this up.
INSERT INTO dron_ingredient(subject, predicate, object, datatype) VALUES
('CHEBI:135086', 'DRON:00010000', '235942', 'xsd:string'),
('CHEBI:135086', 'DRON:00010000', '392938', 'xsd:string'),
('CHEBI:135086', 'rdfs:label', 'BUTETAMATE', 'xsd:string'),
('CHEBI:135086', 'rdfs:label', 'Butethamate', 'xsd:string'),
('CHEBI:135621', 'DRON:00010000', '614654', 'xsd:string'),
('CHEBI:135621', 'rdfs:label', 'Metaclazepam hydrochloride', 'xsd:string'),
('CHEBI:145994', 'DRON:00010000', '2284718', 'xsd:string'),
('CHEBI:145994', 'rdfs:label', 'Lumateperone', 'xsd:string'),
('CHEBI:149601', 'DRON:00010000', '2282403', 'xsd:string'),
('CHEBI:149601', 'rdfs:label', 'bempedoic acid', 'xsd:string'),
('CHEBI:15727', 'DRON:00010000', '858857', 'xsd:string'),
('CHEBI:15727', 'rdfs:label', 'L-carnosine', 'xsd:string'),
('CHEBI:15956', 'DRON:00010000', '314583', 'xsd:string'),
('CHEBI:15956', 'rdfs:label', 'Biotin', 'xsd:string'),
('CHEBI:16336', 'DRON:00010000', '62372', 'xsd:string'),
('CHEBI:16336', 'rdfs:label', 'Hyaluronan', 'xsd:string'),
('CHEBI:16811', 'DRON:00010000', '9100', 'xsd:string'),
('CHEBI:16811', 'rdfs:label', 'Methionine', 'xsd:string'),
('CHEBI:17439', 'rdfs:label', 'Vitamin B 12', 'xsd:string'),
('CHEBI:17833', 'DRON:00010000', '1596450', 'xsd:string'),
('CHEBI:17833', 'rdfs:label', 'Gentamicin', 'xsd:string'),
('CHEBI:18067', 'rdfs:label', 'Vitamin K 1', 'xsd:string'),
('CHEBI:2682', 'DRON:00010000', '732', 'xsd:string'),
('CHEBI:2682', 'rdfs:label', 'Amphotericin B', 'xsd:string'),
('CHEBI:27013', 'DRON:00010000', '42934', 'xsd:string'),
('CHEBI:27013', 'rdfs:label', 'Tocopherol', 'xsd:string'),
('CHEBI:27373', 'DRON:00010000', '22701', 'xsd:string'),
('CHEBI:27373', 'rdfs:label', 'Panthenol', 'xsd:string'),
('CHEBI:28304', 'DRON:00010000', '280611', 'xsd:string'),
('CHEBI:28304', 'DRON:00010000', '5224', 'xsd:string'),
('CHEBI:28304', 'DRON:00010000', '67108', 'xsd:string'),
('CHEBI:28304', 'DRON:00010000', '69528', 'xsd:string'),
('CHEBI:28304', 'DRON:00010000', '75960', 'xsd:string'),
('CHEBI:28304', 'rdfs:label', 'Enoxaparin', 'xsd:string'),
('CHEBI:28304', 'rdfs:label', 'Heparin', 'xsd:string'),
('CHEBI:28304', 'rdfs:label', 'bemiparin', 'xsd:string'),
('CHEBI:28304', 'rdfs:label', 'certoparin', 'xsd:string'),
('CHEBI:28304', 'rdfs:label', 'reviparin', 'xsd:string'),
('CHEBI:28940', 'DRON:00010000', '2418', 'xsd:string'),
('CHEBI:28940', 'rdfs:label', 'Cholecalciferol', 'xsd:string'),
('CHEBI:32026', 'DRON:00010000', '155156', 'xsd:string'),
('CHEBI:32026', 'rdfs:label', 'Poloxamer', 'xsd:string'),
('CHEBI:32027', 'DRON:00010000', '1426432', 'xsd:string'),
('CHEBI:32027', 'rdfs:label', 'POLYOXYL 8 STEARATE', 'xsd:string'),
('CHEBI:32159', 'rdfs:label', 'sucralose', 'xsd:string'),
('CHEBI:36773', 'DRON:00010000', '1952', 'xsd:string'),
('CHEBI:36773', 'rdfs:label', 'Camphor', 'xsd:string'),
('CHEBI:4495', 'DRON:00010000', '6054', 'xsd:string'),
('CHEBI:4495', 'rdfs:label', 'Diazoxide', 'xsd:string'),
('CHEBI:4562', 'DRON:00010000', '4025', 'xsd:string'),
('CHEBI:4562', 'rdfs:label', 'Dihydroergotamine', 'xsd:string'),
('CHEBI:46245', 'rdfs:label', 'coenzyme Q10', 'xsd:string'),
('CHEBI:46936', 'DRON:00010000', '39371', 'xsd:string'),
('CHEBI:46936', 'rdfs:label', 'nonivamide', 'xsd:string'),
('CHEBI:52071', 'DRON:00010000', '3274', 'xsd:string'),
('CHEBI:52071', 'DRON:00010000', '3275', 'xsd:string'),
('CHEBI:52071', 'DRON:00010000', '42635', 'xsd:string'),
('CHEBI:52071', 'rdfs:label', 'Dextran 40', 'xsd:string'),
('CHEBI:52071', 'rdfs:label', 'Dextran 70', 'xsd:string'),
('CHEBI:52071', 'rdfs:label', 'Dextran 75', 'xsd:string'),
('CHEBI:52993', 'DRON:00010000', '6470', 'xsd:string'),
('CHEBI:52993', 'rdfs:label', 'Lorazepam', 'xsd:string'),
('CHEBI:53258', 'DRON:00010000', '56466', 'xsd:string'),
('CHEBI:53258', 'rdfs:label', 'sodium citrate', 'xsd:string'),
('CHEBI:61468', 'DRON:00010000', '324072', 'xsd:string'),
('CHEBI:61468', 'rdfs:label', 'Dimethicone 350', 'xsd:string'),
('CHEBI:78886', 'rdfs:label', '2-tert-butylhydroquinone', 'xsd:string'),
('CHEBI:82530', 'rdfs:label', 'ferric oxide, saccharated', 'xsd:string'),
('CHEBI:8397', 'DRON:00010000', '8674', 'xsd:string'),
('CHEBI:8397', 'rdfs:label', 'Prenylamine', 'xsd:string'),
('CHEBI:8768', 'DRON:00010000', '183877', 'xsd:string'),
('CHEBI:8768', 'rdfs:label', 'clofezone', 'xsd:string'),
('CHEBI:9144', 'DRON:00010000', '9794', 'xsd:string'),
('CHEBI:9144', 'rdfs:label', 'Silymarin', 'xsd:string'),
('CHEBI:94449', 'DRON:00010000', '4955', 'xsd:string'),
('CHEBI:94449', 'rdfs:label', 'Glycopyrrolate', 'xsd:string');

-- Add some missing DRON annotations for active ingredients.
-- "has_proper_part some (
--    scattered molecular aggregate
--    and is_bearer_of some active ingredient
--    and BFO:0000071 some INGREDIENT
-- )"
-- TODO: Clean this up.
INSERT INTO dron_ingredient(subject, predicate, object, datatype) VALUES
-- DRON:00040079 CHEBI:28177
('DRON:00040079', 'rdfs:subClassOf', '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"CHEBI:28177"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}', '_JSON'),
-- DRON:00040079 CHEBI:5551
('DRON:00040079', 'rdfs:subClassOf', '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"CHEBI:5551"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}', '_JSON'),
-- DRON:00043307 DRON:00018133
('DRON:00043307', 'rdfs:subClassOf', '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00018133"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}', '_JSON'),
-- DRON:00053664 CHEBI:2679
('DRON:00053664', 'rdfs:subClassOf', '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"CHEBI:2679"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}', '_JSON'),
-- DRON:00053664 CHEBI:4469
('DRON:00053664', 'rdfs:subClassOf', '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"CHEBI:4469"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}', '_JSON'),
-- DRON:00053997 CHEBI:8104
('DRON:00053997', 'rdfs:subClassOf', '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"CHEBI:8104"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}', '_JSON'),
-- DRON:00055354 CHEBI:8093
('DRON:00055354', 'rdfs:subClassOf', '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"CHEBI:8093"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}', '_JSON'),
-- DRON:00057931 CHEBI:5551
('DRON:00057931', 'rdfs:subClassOf', '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"CHEBI:5551"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}', '_JSON'),
-- DRON:00057931 CHEBI:28177
('DRON:00057931', 'rdfs:subClassOf', '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"CHEBI:28177"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}', '_JSON');

-- Assert rdf:type is owl:Class
-- for all ingredient and disposition rows
-- that are define in dron-ingredient.owl
-- as well for all clinical_drug_form_ingredient,
-- clinical_drug_strength, and branded_drug_excitpient rows
-- which are used in dron-ingredient.owl
INSERT OR IGNORE INTO dron_ingredient(subject, predicate, object)
SELECT
    curie AS subject,
    'rdf:type' AS predicate,
    'owl:Class' AS object
FROM (
    SELECT curie FROM dron.ingredient
    UNION
    SELECT curie FROM dron.disposition
    UNION
    SELECT DISTINCT clinical_drug_form AS curie
        FROM dron.clinical_drug_form_ingredient
    UNION
    SELECT DISTINCT clinical_drug AS curie
        FROM dron.clinical_drug_strength
    UNION
    SELECT DISTINCT branded_drug AS curie
        FROM dron.branded_drug_excipient
);

-- Assert rdfs:label annotation
-- for all ingredient and disposition rows.
INSERT OR IGNORE INTO dron_ingredient(subject, predicate, object, datatype)
SELECT
    curie AS subject,
    'rdfs:label' AS predicate,
    label AS object,
    'xsd:string' AS datatype
FROM (
    SELECT curie, label FROM dron.ingredient
    UNION
    SELECT curie, label FROM dron.disposition
);

-- Assert DRON:00010000 'has_RxCUI' annotation.
-- for all ingredient rows.
INSERT OR IGNORE INTO dron_ingredient(subject, predicate, object, datatype)
SELECT
    curie AS subject,
    'DRON:00010000' AS predicate,
    rxcui AS object,
    'xsd:string' AS datatype
FROM dron.ingredient;

-- Assert rdfs:subClassOf BFO:0000016 'disposition'
-- for all disposition rows.
INSERT OR IGNORE INTO dron_ingredient(subject, predicate, object)
SELECT
    curie AS subject,
    'rdfs:subClassOf' AS predicate,
    'BFO:0000016' AS object
FROM dron.disposition;

-- Assert rdfs:subClassOf OBI:0000047 'processed material'
-- for all ingredient rows with DRON IDs.
INSERT OR IGNORE INTO dron_ingredient(subject, predicate, object)
SELECT
    curie AS subject,
    'rdfs:subClassOf' AS predicate,
    'OBI:0000047' AS object
FROM dron.ingredient
WHERE curie LIKE 'DRON:%';

-- Assert rdfs:subClassOf "'has disposition' some DISPOSITION"
-- for all ingredient_disposition rows.
INSERT OR IGNORE INTO dron_ingredient(subject, predicate, object, datatype)
SELECT
    ingredient AS subject,
    'rdfs:subClassOf' AS predicate,
    REPLACE(
        '{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DISPOSITION"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}',
        'DISPOSITION',
        disposition
    ) AS object,
    '_JSON' AS datatype
FROM dron.ingredient_disposition;

-- Assert rdfs:subClassOf
-- "has_proper_part some (
--    scattered molecular aggregate
--    and is_bearer_of some active ingredient
--    and BFO:0000071 some INGREDIENT
-- )"
-- for all clinical_drug_form_ingredient rows.
INSERT OR IGNORE INTO dron_ingredient(subject, predicate, object, datatype)
SELECT
    clinical_drug_form AS subject,
    'rdfs:subClassOf' AS predicate,
    REPLACE(
        '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"INGREDIENT"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}',
        'INGREDIENT',
        ingredient
    ) AS object,
    '_JSON' AS datatype
FROM dron.clinical_drug_form_ingredient;

-- Assert rdfs:subClassOf
-- has_proper_part some (
--   scattered molecular aggregate
--   and is_bearer_of some active ingredient
--   and is_bearer_of some (
--     mass
--     and has measurement unit label value UNIT
--     and has specified numeric value VALUE
--   )
--   and BFO:0000071 some INGREDIENT
-- )
-- for all clinical_drug_strength rows.
INSERT OR IGNORE INTO dron_ingredient(subject, predicate, object, datatype)
SELECT
    clinical_drug AS subject,
    'rdfs:subClassOf' AS predicate,
    REPLACE(
        REPLACE(
            REPLACE(
                '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000028"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"PATO:0000125"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:hasValue":[{"datatype":"_IRI","object":"UNIT"}],"owl:onProperty":[{"datatype":"_IRI","object":"IAO:0000039"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:hasValue":[{"datatype":"xsd:double","object":"STRENGTH"}],"owl:onProperty":[{"datatype":"_IRI","object":"OBI:0001937"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"INGREDIENT"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}',
                'INGREDIENT',
                ingredient
            ),
            'STRENGTH',
            strength
        ),
        'UNIT',
        unit
    ) AS object,
    '_JSON' AS datatype
FROM dron.clinical_drug_strength;

-- Assert rdfs:subClassOf
-- has_proper_part some (
--   scattered molecular aggregate
--   and is_bearer_of some excipient
--   and BFO_0000071 some INGREDIENT
-- )
-- for all branded_drug_excipient rows.
INSERT OR IGNORE INTO dron_ingredient(subject, predicate, object, datatype)
SELECT
    branded_drug AS subject,
    'rdfs:subClassOf' AS predicate,
    REPLACE(
        '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_JSON","object":{"owl:intersectionOf":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_IRI","object":"OBI:0000576"}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRON:00000029"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_JSON","object":{"rdf:first":[{"datatype":"_JSON","object":{"owl:onProperty":[{"datatype":"_IRI","object":"BFO:0000071"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"INGREDIENT"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}}],"rdf:rest":[{"datatype":"_IRI","object":"rdf:nil"}]}}]}}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Class"}]}}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}',
        'INGREDIENT',
        ingredient
    ) AS object,
    '_JSON' AS datatype
FROM dron.branded_drug_excipient;


-- ### RxNorm Drugs

-- Assert some general statements.
INSERT INTO dron_rxnorm VALUES
(1, 0, 'graph', 'obo:dron/dron-rxnorm.owl', 'rdf:type', 'owl:Ontology', '_IRI', NULL),
(1, 0, 'graph', '<http://www.obofoundry.org/ro/ro.owl#has_proper_part>', 'rdf:type', 'owl:ObjectProperty', '_IRI', NULL),
(1, 0, 'graph', '<http://www.obofoundry.org/ro/ro.owl#has_proper_part>', 'rdf:type', 'owl:TransitiveProperty', '_IRI', NULL),
(1, 0, 'graph', '<http://www.obofoundry.org/ro/ro.owl#has_proper_part>', 'rdfs:label', 'has_proper_part', 'xsd:string', NULL),
(1, 0, 'graph', 'RO:0000053', 'rdf:type', 'owl:ObjectProperty', '_IRI', NULL), 
(1, 0, 'graph', 'RO:0000053', 'rdf:type', 'owl:TransitiveProperty', '_IRI', NULL), 
(1, 0, 'graph', 'RO:0000053', 'rdfs:label', 'is_bearer_of', 'xsd:string', NULL), 
(1, 0, 'graph', 'DRON:00000005', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000015', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000017', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000018', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000019', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000020', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000021', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000022', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000024', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000026', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000032', 'rdf:type', 'owl:Class', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00000033', 'rdfs:label', 'anti-malarial function of a drug product', 'xsd:string', NULL), 
(1, 0, 'graph', 'DRON:00000034', 'rdfs:label', 'anti-hypertensive function of a drug product', 'xsd:string', NULL), 
(1, 0, 'graph', 'DRON:00000035', 'rdfs:label', 'analgesic function of a drug product', 'xsd:string', NULL), 
(1, 0, 'graph', 'DRON:00010000', 'rdf:type', 'owl:AnnotationProperty', '_IRI', NULL), 
(1, 0, 'graph', 'DRON:00010000', 'rdfs:label', 'has_RxCUI', 'xsd:string', NULL);

-- Assert rdf:type is owl:Class
-- for all clinical drug form, clinical drug, and branded drug
-- and dispositions in clinical_dru_form_disposition rows.
INSERT INTO dron_rxnorm(subject, predicate, object)
SELECT
    curie AS subject,
    'rdf:type' AS predicate,
    'owl:Class' AS object
FROM (
    SELECT curie FROM dron.clinical_drug_form
    UNION
    SELECT curie FROM dron.clinical_drug
    UNION
    SELECT curie FROM dron.branded_drug
    UNION
    SELECT disposition AS curie FROM dron.clinical_drug_form_disposition
);

-- Assert rdfs:label annotation
-- for all clinical drug form, clinical drug, and branded drug
-- and dispositions in clinical_dru_form_disposition rows.
INSERT INTO dron_rxnorm(subject, predicate, object, datatype)
SELECT
    curie AS subject,
    'rdfs:label' AS predicate,
    label AS object,
    'xsd:string' AS datatype
FROM (
    SELECT curie, label FROM dron.clinical_drug_form
    UNION
    SELECT curie, label FROM dron.clinical_drug
    UNION
    SELECT curie, label FROM dron.branded_drug
    UNION
    SELECT d.curie, d.label
    FROM dron.clinical_drug_form_disposition AS cdfd
    LEFT JOIN dron.disposition AS d
    WHERE cdfd.disposition = d.curie
);

-- Assert DRON:00010000 'has_RxCUI' annotation.
-- for all clinical drug form, clinical drug, and branded drug rows.
INSERT INTO dron_rxnorm(subject, predicate, object, datatype)
SELECT
    curie AS subject,
    'DRON:00010000' AS predicate,
    rxcui AS object,
    'xsd:string' AS datatype
FROM (
    SELECT curie, rxcui FROM dron.clinical_drug_form
    UNION
    SELECT curie, rxcui FROM dron.clinical_drug
    UNION
    SELECT curie, rxcui FROM dron.branded_drug
);

-- Assert rdfs:subClassOf parent drug class
-- for all clinical drug and branded drug rows
INSERT INTO dron_rxnorm(subject, predicate, object)
SELECT
    curie AS subject,
    'rdfs:subClassOf' AS predicate,
    parent AS object
FROM (
    SELECT curie, parent AS parent FROM dron.clinical_drug_form
    UNION
    SELECT curie, clinical_drug_form AS parent FROM dron.clinical_drug
    UNION
    SELECT curie, clinical_drug AS parent FROM dron.branded_drug
);

-- Assert rdfs:subClassOf DRON:00000032 'drug product therapeutic function'
-- for all dispositions in clinical_drug_form_disposition rows.
INSERT INTO dron_rxnorm(subject, predicate, object)
SELECT DISTINCT
    disposition AS subject,
    'rdfs:subClassOf' AS predicate,
    'DRON:00000032' AS object
FROM dron.clinical_drug_form_disposition;

-- Assert rdfs:subClassOf "'has disposition' some DISPOSITION"
-- for all clinical_drug_form_disposition rows.
INSERT INTO dron_rxnorm(subject, predicate, object, datatype)
SELECT
    clinical_drug_form AS subject,
    'rdfs:subClassOf' AS predicate,
    REPLACE(
        '{"owl:onProperty":[{"datatype":"_IRI","object":"RO:0000053"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DISPOSITION"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}',
        'DISPOSITION',
        disposition
    ) AS object,
    '_JSON' AS datatype
FROM dron.clinical_drug_form_disposition;


-- ### NDCs

-- Assert some general statements.
INSERT INTO dron_ndc VALUES
(1, 0, 'graph', 'obo:dron/dron-ndc.owl', 'rdf:type', 'owl:Ontology', '_IRI', NULL),
(1, 0, 'graph', '<http://www.obofoundry.org/ro/ro.owl#has_proper_part>', 'rdf:type', 'owl:ObjectProperty', '_IRI', NULL),
(1, 0, 'graph', '<http://www.obofoundry.org/ro/ro.owl#has_proper_part>', 'rdf:type', 'owl:TransitiveProperty', '_IRI', NULL),
(1, 0, 'graph', '<http://www.obofoundry.org/ro/ro.owl#has_proper_part>', 'rdfs:label', 'has_proper_part', 'xsd:string', NULL),
(1, 0, 'graph', 'DRON:00000027', 'rdf:type', 'owl:Class', '_IRI', NULL); 

-- Assert rdf:type is owl:Class
-- for all NDCs: branded drug and clinical drug.
INSERT INTO dron_ndc(subject, predicate, object)
SELECT
    curie AS subject,
    'rdf:type' AS predicate,
    'owl:Class' AS object
FROM (
    SELECT curie FROM dron.ndc_branded_drug
    UNION
    SELECT branded_drug AS curie FROM dron.ndc_branded_drug
    UNION
    SELECT curie FROM dron.ndc_clinical_drug
    UNION
    SELECT clinical_drug AS curie FROM dron.ndc_clinical_drug
);

-- Assert rdfs:label annotation
-- for all NDCs: branded drug and clinical drug.
INSERT INTO dron_ndc(subject, predicate, object, datatype)
SELECT
    curie AS subject,
    'rdfs:label' AS predicate,
    ndc AS object,
    'xsd:string' AS datatype
FROM (
    SELECT curie, ndc FROM dron.ndc_branded_drug
    UNION
    SELECT curie, ndc FROM dron.ndc_clinical_drug
);

-- Assert rdfs:subClassOf DRON:00000027 'packaged drug product'
-- for all NDCs: branded drug and clinical drug.
INSERT INTO dron_ndc(subject, predicate, object)
SELECT
    curie AS subject,
    'rdfs:subClassOf' AS predicate,
    'DRON:00000027' AS object
FROM (
    SELECT curie FROM dron.ndc_branded_drug
    UNION
    SELECT curie FROM dron.ndc_clinical_drug
);

-- Assert rdfs:subClassOf "'has proper part' some DRUG"
-- for all NDCs: branded drug and clinical drug.
INSERT INTO dron_ndc(subject, predicate, object, datatype)
SELECT
    curie AS subject,
    'rdfs:subClassOf' AS predicate,
    REPLACE(
        '{"owl:onProperty":[{"datatype":"_IRI","object":"<http://www.obofoundry.org/ro/ro.owl#has_proper_part>"}],"owl:someValuesFrom":[{"datatype":"_IRI","object":"DRUG"}],"rdf:type":[{"datatype":"_IRI","object":"owl:Restriction"}]}',
        'DRUG',
        drug
    ) AS object,
    '_JSON' AS datatype
FROM (
    SELECT curie, branded_drug AS drug FROM dron.ndc_branded_drug
    UNION
    SELECT curie, clinical_drug AS drug FROM dron.ndc_clinical_drug
);


-- ## Obsolete Terms

INSERT INTO dron_obsolete(subject, predicate, object) VALUES
('obo:dron/dron-obsolete.owl', 'rdf:type', 'owl:Ontology');

INSERT OR IGNORE INTO dron_obsolete(subject, predicate, object)
SELECT
    curie AS subject,
    'rdf:type' AS predicate,
    type AS object
FROM obsolete;

INSERT OR IGNORE INTO dron_obsolete(subject, predicate, object, datatype)
SELECT
    curie AS subject,
    'rdfs:label' AS predicate,
    label AS object,
    'xsd:string' AS datatype
FROM obsolete;

INSERT OR IGNORE INTO dron_obsolete(subject, predicate, object, datatype)
SELECT
    curie AS subject,
    'owl:deprecated' AS predicate,
    'true' AS object,
    'xsd:boolean' AS datatype
FROM obsolete;

INSERT OR IGNORE INTO dron_obsolete(subject, predicate, object)
SELECT
    curie AS subject,
    'IAO:0100001' AS predicate,
    replaced_by AS object
FROM obsolete
WHERE replaced_by IS NOT NULL
  AND replaced_by != '';
