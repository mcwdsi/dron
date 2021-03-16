---
layout: ontology_detail
id: dron
title: The Drug Ontology
jobs:
  - id: https://travis-ci.org/uamsdbmi/dron
    type: travis-ci
build:
  checkout: git clone https://github.com/uamsdbmi/dron.git
  system: git
  path: "."
contact:
  email: 
  label: 
  github: 
description: The Drug Ontology is an ontology...
domain: stuff
homepage: https://github.com/uamsdbmi/dron
products:
  - id: dron.owl
    name: "The Drug Ontology main release in OWL format"
  - id: dron.obo
    name: "The Drug Ontology additional release in OBO format"
  - id: dron.json
    name: "The Drug Ontology additional release in OBOJSon format"
  - id: dron/dron-base.owl
    name: "The Drug Ontology main release in OWL format"
  - id: dron/dron-base.obo
    name: "The Drug Ontology additional release in OBO format"
  - id: dron/dron-base.json
    name: "The Drug Ontology additional release in OBOJSon format"
dependencies:
- id: ro
- id: bfo
- id: omo
- id: chebi
- id: pr

tracker: https://github.com/uamsdbmi/dron/issues
license:
  url: http://creativecommons.org/licenses/by/3.0/
  label: CC-BY
activity_status: active
---

Enter a detailed description of your ontology here. You can use arbitrary markdown and HTML.
You can also embed images too.

