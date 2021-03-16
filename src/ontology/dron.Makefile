## Customize Makefile settings for dron
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

##################################
#### Custom release artefacts ####
##################################

# The following describes the definition of the dron-lite release. 
# In essence we merge rxnorm, dron-ingredient, all imports and the edit file
# (no NDC) and the run a regular full release.

LITE_ARTEFACTS=components/dron-rxnorm.owl components/dron-ingredient.owl $(IMPORT_OWL_FILES)
$(TMPDIR)/dron-edit_lite.owl: $(SRC) $(LITE_ARTEFACTS)
	$(ROBOT) remove --input $(SRC) --select imports \
	merge $(patsubst %, -i %, $(LITE_ARTEFACTS)) --output $@.tmp.owl && mv $@.tmp.owl $@

dron-lite.owl: $(TMPDIR)/dron-edit_lite.owl
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed all --exclude-tautologies structural \
		relax \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@


$(TMPDIR)/export_dron-%.tsv: components/dron-%.owl | $(TMPDIR)
	$(ROBOT) export --input $< \
  --header "ID|Type|LABEL|has_obo_namespace|SubClass Of|definition|hasDbXref|comment|hasExactSynonym|has_narrow_synonym|hasRelatedSynonym|created_by|creation_date|in_subset|has_alternative_id" \
  --include "classes properties" \
  --export $@

export: $(TMPDIR)/export_dron-hand.tsv

unsat: tmp/dron_unsat.ofn
	
tmp/dron_unsat.ofn: $(SRC)
	robot merge --input $< explain --reasoner ELK \
  -M unsatisfiability --unsatisfiable all --explanation $@.md \
    annotate --ontology-iri "$(ONTBASE)/$@" \
    --output $@

reports/dron-%.tsv: components/dron-%.owl
	$(ROBOT) query -i $< --query ../sparql/dron-$*.sparql $@
	cat $@ | sed 's|http://purl.obolibrary.org/obo/DRON_|DRON:|g' | sed 's|http://purl.obolibrary.org/obo/CHEBI_|CHEBI:|g' | sed 's|http://purl.obolibrary.org/obo/OBI_|OBI:|g' | sed 's|http://www.w3.org/2002/07/owl#|owl:|g' | sed 's/[<>]//g' > $@.tmp && mv $@.tmp $@
	
reports/template-dron-ingredient.tsv: reports/dron-ingredient.tsv
	sed -i '1d' reports/dron-ingredient.tsv > $@
	echo "ID	LABEL	TYPE	PARENT	RXCUI	p1_bfo53	p1_bfo71	p1_genus	BEARER\nID	LABEL	TYPE	SC %	A DRON:00010000			SC 'is bearer of' some % SPLIT=|" | cat - reports/dron-ingredient.tsv > $@.tmp && mv $@.tmp $@
	echo "BFO:0000053	is bearer of	owl:ObjectProperty			" >> $@

reports/template-dron-ndc.tsv: reports/dron-ndc.tsv
	sed -i '1d' reports/dron-ndc.tsv > $@
	echo "ID	LABEL	TYPE	PARENT	BEARER\nID	LABEL	TYPE	SC %	SC 'has_proper_part' some % SPLIT=|" | cat - reports/dron-ndc.tsv > $@.tmp && mv $@.tmp $@
	echo "http://www.obofoundry.org/ro/ro.owl#has_proper_part	has_proper_part	owl:ObjectProperty			" >> $@

reports/template-dron-rxnorm.tsv: reports/dron-rxnorm.tsv
	sed -i '1d' reports/dron-rxnorm.tsv > $@
	echo "ID	LABEL	TYPE	PARENT	RXCUI	BEARER\nID	LABEL	TYPE	SC %	A DRON:00010000	SC 'is bearer of' some % SPLIT=|" | cat - reports/dron-rxnorm.tsv > $@.tmp && mv $@.tmp $@
	echo "BFO:0000053	is bearer of	owl:ObjectProperty			" >> $@

reports/template-%.owl: reports/template-%.tsv
	$(ROBOT) template --template $< \
  --ontology-iri "$(ONTBASE)/$@" \
  --output $@

tables: reports/dron-rxnorm.tsv reports/dron-ingredient.tsv reports/dron-ndc.tsv
	
tmp/unmerge-%.owl: components/dron-%.owl reports/template-dron-%.owl
	$(ROBOT) merge -i $< unmerge -i reports/template-dron-$*.owl convert -f ofn -o $@

tmp/unmerge-%.ttl: tmp/unmerge-%.owl
	$(ROBOT) convert -i $< -f ttl -o $@

tmp/unmerge-ingredient.owl:
	echo "skipped"

unmerge: tmp/unmerge-ingredient.owl tmp/unmerge-ingredient.ttl
unmerge: tmp/unmerge-ndc.owl tmp/unmerge-ndc.owl tmp/unmerge-rxnorm.owl
	
tmp/rename-%.owl: tmp/%.owl
	$(ROBOT) rename -i $< --mappings config/rename.tsv -o $@

ALL_PATTERNS=$(patsubst ../patterns/dosdp-patterns/%.yaml,%,$(wildcard ../patterns/dosdp-patterns/[a-z]*.yaml))

.PHONY: dirs
dirs:
	mkdir -p tmp/
	mkdir -p components/


.PHONY: matches
	
matches:
	dosdp-tools query --ontology=tmp/rename-unmerge-ingredient.owl --catalog=catalog-v001.xml --reasoner=elk --obo-prefixes=true --batch-patterns="$(ALL_PATTERNS)" --template="../patterns/dosdp-patterns" --outfile="../patterns/data/matches/"

DRON_RELEASE_LOCATION=https://bitbucket.org/uamsdbmi/dron/raw/master/
DRON_NDC_RELEASE=$(DRON_RELEASE_LOCATION)/dron-ndc.owl
DRON_RXNORM_RELEASE=$(DRON_RELEASE_LOCATION)/dron-rxnorm.owl
DRON_INGREDIENTS_RELEASE=$(DRON_RELEASE_LOCATION)/dron-ingredient.owl

reset_components:
	echo "Resetting components to the last release. This is usually only necessary when the project is cloned on a new machine."
	wget $(DRON_NDC_RELEASE) -O components/dron-ndc.owl
	wget $(DRON_RXNORM_RELEASE) -O components/dron-rxnorm.owl
	wget $(DRON_INGREDIENTS_RELEASE) -O components/dron-ingredient.owl


################################
## From March 2021 Migration ###
################################

merge_release:
	$(ROBOT) merge -i $(SRC) -i components/dron-hand.owl  -i components/dron-upper.owl --collapse-import-closure false -o $(SRC).ofn
