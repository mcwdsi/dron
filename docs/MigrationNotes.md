# ODK Migration March 2021

This document summarises the migration process to regular ODK setup in March 2021. It mainly serves historical purposes, tracing some of the decisions that were made.

The original repo of Dron was on bitbucket: https://bitbucket.org/uamsdbmi/dron

To make use of the GitHub ecosystem (GitHub actions for CI, GitHub releases), we migrated Dron to GitHub as well. This migration had one major downside: the GitHub maximum file size is 100 MB. This had two consequences:
1. Large Dron components (dron-ndc, dron-ingredient and dron-rxnorm) could not be checked in directly.
2. The Dron history could not be migrated, as the file size restriction applies to the git history as well.


The remainder of the documents details the other key changes.

## Merge upper and hand into a single file

All the manually edited Dron axioms are now edited in `src/ontology/dron-edit.owl`. `dron-upper.owl` and `dron-hand.owl`, previously managed as separated OWL files, were merged into the new edit file as follows:

```
merge_release:
	$(ROBOT) merge -i $(SRC) -i components/dron-hand.owl  -i components/dron-upper.owl --collapse-import-closure false -o $(SRC).ofn && mv $(SRC).ofn $(SRC)
```
