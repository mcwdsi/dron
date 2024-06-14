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

LITE_ARTEFACTS=$(COMPONENTSDIR)/dron-rxnorm.owl $(COMPONENTSDIR)/dron-ingredient.owl $(COMPONENTSDIR)/dron-obsolete.owl $(IMPORT_OWL_FILES)
$(TMPDIR)/dron-edit_lite.owl: $(SRC) $(LITE_ARTEFACTS)
	$(ROBOT) remove --input $(SRC) --select imports \
	merge $(patsubst %, -i %, $(LITE_ARTEFACTS)) --output $@.tmp.owl && mv $@.tmp.owl $@

dron-lite.owl: $(TMPDIR)/dron-edit_lite.owl
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed all --exclude-tautologies structural \
		relax \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@

###################################
#### Create OWL from templates ####
###################################

$(TMPDIR)/ldtab.jar: | $(TMPDIR)
	wget https://github.com/ontodev/ldtab.clj/releases/download/v2024-05-14/ldtab.jar -O $@

LDTAB := java -jar $(TMPDIR)/ldtab.jar

# Load DrOn templates into SQLite.
$(TMPDIR)/dron.db: $(SCRIPTSDIR)/create-dron-tables.sql $(SCRIPTSDIR)/load-dron-tables.sql
	rm -f $@
	sqlite3 $@ < $<
	sqlite3 $@ < $(word 2,$^)
 
# Load ChEBI into SQLite using LDTab.
$(TMPDIR)/chebi.db: $(SCRIPTSDIR)/prefix.tsv $(TMPDIR)/mirror-chebi.owl | $(TMPDIR)/ldtab.jar
	$(eval DB=$@)
	rm -f $@
	$(LDTAB) init $(DB) --table chebi
	$(LDTAB) prefix $(DB) $<
	$(LDTAB) import $(DB) $(word 2,$^) --table chebi
	sqlite3 $(DB) "CREATE INDEX idx_chebi_subject ON chebi(subject)"
	sqlite3 $(DB) "CREATE INDEX idx_chebi_predicate ON chebi(predicate)"
	sqlite3 $(DB) "CREATE INDEX idx_chebi_object ON chebi(object)"

# Create a SQLite database for RxNorm and load data from tmp/rxnorm/*.RRF.
$(TMPDIR)/rxnorm.db: $(SCRIPTSDIR)/create-rxnorm-tables.sql $(SCRIPTSDIR)/load-rxnorm-tables.sql $(SCRIPTSDIR)/index-rxnorm-tables.sql | $(TMPDIR)/
	rm -f $@
	sqlite3 $@ < $<
	sqlite3 $@ < $(word 2,$^) 2> /dev/null
	sqlite3 $@ < $(word 3,$^)

.PHONY: update-labels
update-labels: $(TMPDIR)/dron.db $(TMPDIR)/chebi.db $(TMPDIR)/rxnorm.db $(SCRIPTSDIR)/update-labels.sql $(SCRIPTSDIR)/save-dron-tables.sql
	sqlite3 < $(word 4,$^)
	cd $(TEMPLATEDIR) && sqlite3 ../ontology/$< < ../ontology/$(word 5,$^)

# Convert DrOn template tables to LDTab format tables.
$(TMPDIR)/ldtab.db: $(TMPDIR)/dron.db $(SCRIPTSDIR)/prefix.tsv $(SCRIPTSDIR)/convert-dron-ldtab.sql | $(TMPDIR)/ldtab.jar
	$(eval DB=$@)
	rm -f $@
	$(LDTAB) init $(DB) --table dron_ingredient
	$(LDTAB) init $(DB) --table dron_rxnorm
	$(LDTAB) init $(DB) --table dron_ndc
	$(LDTAB) init $(DB) --table dron_obsolete
	$(LDTAB) prefix $@ $(word 2,$^)
	sqlite3 $@ < $(word 3,$^)

# Export an LDTab table to Turtle format.
$(COMPONENTSDIR)/dron-%.ttl: $(TMPDIR)/ldtab.db | $(COMPONENTSDIR)
	rm -f $@
	$(LDTAB) export $< $@ --table dron_$*

# Convert a Turtle file to an OWL file in RDFXML format.
$(COMPONENTSDIR)/%.owl: $(COMPONENTSDIR)/%.ttl
	$(ROBOT) convert -i $< -o $@

# Override the all_components task.
all_components: $(COMPONENTSDIR)/dron-ingredient.ttl $(COMPONENTSDIR)/dron-rxnorm.ttl $(COMPONENTSDIR)/dron-ndc.ttl $(COMPONENTSDIR)/dron-obsolete.ttl $(COMPONENTSDIR)/dron-ingredient.owl $(COMPONENTSDIR)/dron-rxnorm.owl $(COMPONENTSDIR)/dron-ndc.owl $(COMPONENTSDIR)/dron-obsolete.owl

###################################
#### Create templates from OWL ####
###################################

# Convert component OWL files to DrOn templates.
# This should be a one-time action
# when migrating away from the old Scala DrOn build system,
# but it could also be helpful for testing changes to new build scripts.

$(TMPDIR)/reverse/:
	mkdir -p $@

# Convert components from OFN to OWL for LDTab to import.
$(TMPDIR)/reverse/dron-%.owl: components.bk/dron-%.owl | $(TMPDIR)/reverse/
	$(ROBOT) convert -i $< -o $@

$(TMPDIR)/reverse.db: $(SCRIPTSDIR)/prefix.tsv $(SCRIPTSDIR)/create-dron-tables.sql $(SCRIPTSDIR)/convert-ldtab-dron.sql $(TMPDIR)/reverse/dron-ingredient.owl $(TMPDIR)/reverse/dron-rxnorm.owl $(TMPDIR)/reverse/dron-ndc.owl $(TMPDIR)/reverse/dron-obsolete.owl | $(TMPDIR)/ldtab.jar
	$(eval DB=$@)
	rm -f $(DB)
	$(LDTAB) init $(DB) --table dron_ingredient
	$(LDTAB) init $(DB) --table dron_rxnorm
	$(LDTAB) init $(DB) --table dron_ndc
	$(LDTAB) init $(DB) --table dron_obsolete
	$(LDTAB) prefix $(DB) $<
	sqlite3 $(DB) < $(word 2,$^)
	$(LDTAB) import $(DB) --table dron_ingredient $(TMPDIR)/reverse/dron-ingredient.owl
	$(LDTAB) import $(DB) --table dron_rxnorm $(TMPDIR)/reverse/dron-rxnorm.owl
	$(LDTAB) import $(DB) --table dron_ndc $(TMPDIR)/reverse/dron-ndc.owl
	$(LDTAB) import $(DB) --table dron_obsolete $(TMPDIR)/reverse/dron-obsolete.owl

.PHONY: reverse
reverse: $(TMPDIR)/reverse.db $(SCRIPTSDIR)/save-dron-tables.sql
	# Save template tables to TSV
	cd $(TMPDIR)/reverse/ && sqlite3 ../../$< < ../../$(word 2,$^)
	# Copy to src/templates/
	cp $(TMPDIR)/reverse/*.tsv $(TEMPLATEDIR)

###########################
#### Roundtrip testing ####
###########################

# Export LDTab tables as TSV and sort them for diffing.

.PRECIOUS: $(COMPONENTSDIR)/dron-%.tsv
$(COMPONENTSDIR)/dron-%.tsv: $(COMPONENTSDIR)/dron-%.owl
	$(eval DB=$(TMPDIR)/ldtab.db)
	rm -f $@
	$(LDTAB) export $(DB) $@ --table dron_$* --sort

.PRECIOUS: $(TMPDIR)/reverse/dron-%.tsv
$(TMPDIR)/reverse/dron-%.tsv: | $(TMPDIR)/reverse.db
	$(eval DB=$|)
	rm -f $@
	$(LDTAB) export $(DB) $@ --table dron_$* --sort

$(TMPDIR)/%.tsv.diff: $(TMPDIR)/reverse/%.tsv $(COMPONENTSDIR)/%.tsv
	-diff -u $^ > $@

$(TMPDIR)/%.owl.diff: $(TMPDIR)/reverse/%.owl $(COMPONENTSDIR)/%.owl
	-diff -u $^ > $@

.PHONY: roundtrip
roundtrip: $(COMPONENTSDIR)/dron-ingredient.ttl $(COMPONENTSDIR)/dron-rxnorm.ttl $(COMPONENTSDIR)/dron-ndc.ttl $(COMPONENTSDIR)/dron-obsolete.ttl $(TMPDIR)/dron-ingredient.owl.diff $(TMPDIR)/dron-ingredient.tsv.diff $(TMPDIR)/dron-rxnorm.owl.diff $(TMPDIR)/dron-rxnorm.tsv.diff $(TMPDIR)/dron-ndc.owl.diff $(TMPDIR)/dron-ndc.tsv.diff $(TMPDIR)/dron-obsolete.owl.diff $(TMPDIR)/dron-obsolete.tsv.diff
