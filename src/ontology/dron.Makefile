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

##################################
#### Create tempates from OWL ####
##################################

$(TMPDIR)/ldtab.jar: | $(TMPDIR)
	wget https://github.com/ontodev/ldtab.clj/releases/download/v2023-12-21/ldtab.jar -O $@

LDTAB := java -jar $(TMPDIR)/ldtab.jar

$(TMPDIR)/reverse/:
	mkdir -p $@

# Convert components from OFN to OWL for LDTab.
$(TMPDIR)/reverse/dron-%.owl: $(COMPONENTSDIR)/dron-%.owl | $(TMPDIR)/reverse/
	$(ROBOT) convert -i $< -o $@

# Convert component OWL files to DrOn templates.
# This should be a one-time action
# when migrating away from the old Scala DrOn build system,
# but it could also be helpful for testing changes to new build scripts.
.PHONY: reverse
reverse: $(SCRIPTSDIR)/prefix.tsv $(SCRIPTSDIR)/create-dron-tables.sql $(SCRIPTSDIR)/convert-ldtab-dron.sql $(SCRIPTSDIR)/save-dron-tables.sql $(TMPDIR)/reverse/dron-ingredient.owl $(TMPDIR)/reverse/dron-rxnorm.owl $(TMPDIR)/reverse/dron-ndc.owl | $(TMPDIR)/ldtab.jar
	$(eval DB=$(TMPDIR)/reverse.db)
	rm -f $(DB)
	$(LDTAB) init $(DB) --table dron_ingredient
	$(LDTAB) init $(DB) --table dron_rxnorm
	$(LDTAB) init $(DB) --table dron_ndc
	$(LDTAB) prefix $(DB) $<
	sqlite3 $(DB) < $(word 2,$^)
	$(LDTAB) import $(DB) --table dron_ingredient $(TMPDIR)/reverse/dron-ingredient.owl
	$(LDTAB) import $(DB) --table dron_rxnorm $(TMPDIR)/reverse/dron-rxnorm.owl
	$(LDTAB) import $(DB) --table dron_ndc $(TMPDIR)/reverse/dron-ndc.owl
	sqlite3 $(DB) < $(word 3,$^)
	cd $(TMPDIR)/reverse/ && sqlite3 ../../$(DB) < ../../$(word 4,$^)
	cp $(TMPDIR)/reverse/*.tsv $(TEMPLATEDIR)
