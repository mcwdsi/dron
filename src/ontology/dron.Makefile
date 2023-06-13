## Customize Makefile settings for dron
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

##################################
#### Custom release artefacts ####
##################################

define swap_chebi
    $(ROBOT) rename -i $(1) --mappings mappings/dron-chebi-mapping.csv --allow-missing-entities true --allow-duplicates true convert -f ofn -o $(1)
endef

# The following describes the definition of the dron-lite release. 
# In essence we merge rxnorm, dron-ingredient, all imports and the edit file
# (no NDC) and the run a regular full release.

LITE_ARTEFACTS=$(COMPONENTSDIR)/dron-rxnorm.owl $(COMPONENTSDIR)/dron-ingredient.owl $(IMPORT_OWL_FILES)
$(TMPDIR)/dron-edit_lite.owl: $(SRC) $(LITE_ARTEFACTS)
	$(ROBOT) remove --input $(SRC) --select imports \
	merge $(patsubst %, -i %, $(LITE_ARTEFACTS)) --output $@.tmp.owl && mv $@.tmp.owl $@

dron-lite.owl: $(TMPDIR)/dron-edit_lite.owl
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed all --exclude-tautologies structural \
		relax \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@


# export: $(TMPDIR)/export_dron-hand.tsv
# 
# $(TMPDIR)/export_dron-%.tsv: $(COMPONENTSDIR)/dron-%.owl | $(TMPDIR)
# 	$(ROBOT) export --input $< \
#   --header "ID|Type|LABEL|has_obo_namespace|SubClass Of|definition|hasDbXref|comment|hasExactSynonym|has_narrow_synonym|hasRelatedSynonym|created_by|creation_date|in_subset|has_alternative_id" \
#   --include "classes properties" \
#   --export $@
# reports/dron-%.tsv: $(COMPONENTSDIR)/dron-%.owl
# 	$(ROBOT) query -i $< --query ../sparql/dron-$*.sparql $@
# 	cat $@ | sed 's|http://purl.obolibrary.org/obo/DRON_|DRON:|g' | sed 's|http://purl.obolibrary.org/obo/CHEBI_|CHEBI:|g' | sed 's|http://purl.obolibrary.org/obo/OBI_|OBI:|g' | sed 's|http://www.w3.org/2002/07/owl#|owl:|g' | sed 's/[<>]//g' > $@.tmp && mv $@.tmp $@
# 
# reports/template-dron-ingredient.tsv: reports/dron-ingredient.tsv
# 	sed -i '1d' reports/dron-ingredient.tsv > $@
# 	echo "ID	LABEL	TYPE	PARENT	RXCUI	p1_bfo53	p1_bfo71	p1_genus	BEARER\nID	LABEL	TYPE	SC %	A DRON:00010000			SC 'is bearer of' some % SPLIT=|" | cat - reports/dron-ingredient.tsv > $@.tmp && mv $@.tmp $@
# 	echo "BFO:0000053	is bearer of	owl:ObjectProperty			" >> $@
# 
# reports/template-dron-ndc.tsv: reports/dron-ndc.tsv
# 	sed -i '1d' reports/dron-ndc.tsv > $@
# 	echo "ID	LABEL	TYPE	PARENT	BEARER\nID	LABEL	TYPE	SC %	SC 'has_proper_part' some % SPLIT=|" | cat - reports/dron-ndc.tsv > $@.tmp && mv $@.tmp $@
# 	echo "http://www.obofoundry.org/ro/ro.owl#has_proper_part	has_proper_part	owl:ObjectProperty			" >> $@
# 
# reports/template-dron-rxnorm.tsv: reports/dron-rxnorm.tsv
# 	sed -i '1d' reports/dron-rxnorm.tsv > $@
# 	echo "ID	LABEL	TYPE	PARENT	RXCUI	BEARER\nID	LABEL	TYPE	SC %	A DRON:00010000	SC 'is bearer of' some % SPLIT=|" | cat - reports/dron-rxnorm.tsv > $@.tmp && mv $@.tmp $@
# 	echo "BFO:0000053	is bearer of	owl:ObjectProperty			" >> $@
# 
# reports/template-%.owl: reports/template-%.tsv
# 	$(ROBOT) template --template $< \
#   --ontology-iri "$(ONTBASE)/$@" \
#   --output $@
# 
# tables: reports/dron-rxnorm.tsv reports/dron-ingredient.tsv reports/dron-ndc.tsv
# 
# tmp/unmerge-%.owl: $(COMPONENTSDIR)/dron-%.owl reports/template-dron-%.owl
# 	$(ROBOT) merge -i $< unmerge -i reports/template-dron-$*.owl convert -f ofn -o $@
# 
# tmp/unmerge-%.ttl: tmp/unmerge-%.owl
# 	$(ROBOT) convert -i $< -f ttl -o $@
# 
# tmp/unmerge-ingredient.owl:
# 	echo "skipped"
# 
# unmerge: tmp/unmerge-ingredient.owl tmp/unmerge-ingredient.ttl
# unmerge: tmp/unmerge-ndc.owl tmp/unmerge-ndc.owl tmp/unmerge-rxnorm.owl
# 
# tmp/rename-%.owl: tmp/%.owl
# 	$(ROBOT) rename -i $< --mappings config/rename.tsv -o $@
# 
# ALL_PATTERNS=$(patsubst ../patterns/dosdp-patterns/%.yaml,%,$(wildcard ../patterns/dosdp-patterns/[a-z]*.yaml))
# 
# .PHONY: matches	
# matches:
# 	dosdp-tools query --ontology=tmp/rename-unmerge-ingredient.owl --catalog=catalog-v001.xml --reasoner=elk --obo-prefixes=true --batch-patterns="$(ALL_PATTERNS)" --template="../patterns/dosdp-patterns" --outfile="../patterns/data/matches/"

DRON_RELEASE_LOCATION=https://drugontology.s3.amazonaws.com
DRON_NDC_RELEASE=$(DRON_RELEASE_LOCATION)/dron-ndc.owl
DRON_RXNORM_RELEASE=$(DRON_RELEASE_LOCATION)/dron-rxnorm.owl
DRON_INGREDIENTS_RELEASE=$(DRON_RELEASE_LOCATION)/dron-ingredient.owl

download_components:
	echo "Resetting components to the last release. This is usually only necessary when the project is cloned on a new machine."
	mkdir -p $(COMPONENTSDIR)
	wget $(DRON_NDC_RELEASE) -O $(COMPONENTSDIR)/dron-ndc.owl
	$(call swap_chebi,$(COMPONENTSDIR)/dron-ndc.owl)
	wget $(DRON_RXNORM_RELEASE) -O $(COMPONENTSDIR)/dron-rxnorm.owl
	$(call swap_chebi,$(COMPONENTSDIR)/dron-rxnorm.owl)
	wget $(DRON_INGREDIENTS_RELEASE) -O $(COMPONENTSDIR)/dron-ingredient.owl
	$(call swap_chebi,$(COMPONENTSDIR)/dron-ingredient.owl)
	grep -v "SubClassOf.*CHEBI_.*/OBI_0000047" components/dron-ingredient.owl > components/dron-ingredient-remediated.owl
	mv components/dron-ingredient.owl components/dron-ingredient-initial.owl
	mv components/dron-ingredient-remediated.owl components/dron-ingredient.owl 

################################
## From March 2021 Migration ###
################################

# tmp/dron-edit-external.ofn: $(SRC)
# 	$(ROBOT) filter --input $< \
#   --select "DRON:*" \
# 	--select complement \
#   --preserve-structure false \
#   --output $@
# 
# 
# unmerge_src:
# 	$(ROBOT) merge -i $(SRC) --collapse-import-closure false unmerge -i tmp/dron-edit-external.ofn convert -f ofn -o $(SRC)
# 
# 
# merge_release:
# 	$(ROBOT) merge -i $(SRC) -i $(COMPONENTSDIR)/dron-hand.owl  -i $(COMPONENTSDIR)/dron-upper.owl --collapse-import-closure false -o $(SRC).ofn

##### Diff #####

tmp/$(ONT)-build.owl:
	cp ../../$(ONT).owl $@
	
tmp/$(ONT)-merged.owl: $(SRC)
	$(ROBOT) merge -i $< -o $@

tmp/$(ONT)-release.owl:
	$(ROBOT) merge -I http://purl.obolibrary.org/obo/$(ONT).owl -o $@

reports/release-diff-%.md: tmp/$(ONT)-release.owl tmp/$(ONT)-%.owl
	$(ROBOT) diff --left $< --right tmp/$(ONT)-$*.owl -f markdown -o $@

reports/release-diff-%.txt: tmp/$(ONT)-release.owl tmp/$(ONT)-%.owl
	$(ROBOT) diff --left $< --right tmp/$(ONT)-$*.owl -o $@
	
reports/dron-release-diff-%.txt: reports/release-diff-%.txt
	grep DRON_ $< > $@

release_diff: reports/release-diff-build.md reports/release-diff-build.txt
release_diff: reports/release-diff-merged.md reports/release-diff-merged.txt
release_diff: reports/dron-release-diff-build.txt
release_diff: reports/dron-release-diff-merged.txt

.PHONY: unsat
unsat: tmp/dron_unsat.ofn
	
tmp/dron_unsat.ofn: $(SRC)
	robot merge --input $< explain --reasoner ELK \
  -M unsatisfiability --unsatisfiable all --explanation $@.md \
    annotate --ontology-iri "$(ONTBASE)/$@" \
    --output $@

.PHONY: swap_chebi_in_edit
swap_chebi_in_edit:
	 $(call swap_chebi,$(SRC))
