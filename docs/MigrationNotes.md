# ODK Migration March 2021

This document summarises the migration process to regular ODK setup in March 2021. It mainly serves historical purposes, tracing some of the decisions that were made, but also provides guidance on how to manage the migration process on the UFBMI side.

The original repo of DrOn was on bitbucket: https://bitbucket.org/uamsdbmi/dron

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

## Comparing the new ODK-based dron.owl with the old dron.owl

The new DrOn release is a bit different than the old one. In the following we will discuss the differences in detail.

1. *Added imports*. Same as in other ontologies, such as OMRSE, we added proper imports to the Relation Ontology RO and BFO. This ensures that DRON modelling is logically consistent with the BFO worldview, which keeps it compatible with other OBO/BFO-based ontologies. This means there are a few changes in and around external axioms, such as:
    - include BFO/RO axioms
    - added/removed CHEBI axioms
    - added/removed PRO axioms
2. *Inferred subclasses*. If you open `src/ontology/dron-edit.owl` and run the reasoner, you will notice that DrOn has a good number of inferred-only subsumptions. Inferred-only subsumptions are those that the reasoner can deduce from the given axioms, but that are not *asserted* as a SubClassOf axiom. Example, if you run the reasoner in Protege, you will find that [Ampicillin / cloxacillin suspension](http://purl.obolibrary.org/obo/DRON_00001110) is asserted to be a subclass of `drug suspension`. However, you will also notice that it can be inferred to be a SubClassOf `cloxacillin suspension`:

[[img/inferred_subs.png]]

It is important to remember that the standard ROBOT pipeline for the main ontology release a) runs the reasoner and b) strips out redundant axioms, see [here](https://github.com/INCATools/ontology-development-kit/blob/master/docs/ReleaseArtefacts.md#release-artefact-2-full-required).
3. *Axiom removed due to unsatisfiability*: See [issue](https://github.com/matentzn/dron/issues/2)

## Migration checklist for the DrOn team

The following section is intended as a guide for the DrOn team to fully migrate to the new ODK version of DrOn. The steps that need to be taken are as follows:

1. Perform the repo review (see below)
2. Migrate the GitHub repo to the `ufbmi` GitHub organisation
3. Make a test release according [the instructions](DronReleaseWorkflow.md)

If there are problems along the way, the Knocean team will help you sort them out.

Below, we will first provide some instructions for a *shallow must-do* review, and then give some pointers to additional stuff that could be reviewed if the DrOn team is so inclined. 

### Instructions for shallow review
_Note:_ When reviewing diffs, its good to keep in mind that lines starting with a `-` have been removed from the original DrOn, and lines with a `+` have been added.

- Open ODK-based dron.owl (top level of GitHub repo) in Protege, side by side with the current dron.owl release (from Bitbucket) and spent 10 minutes looking for oddities in the upper levels of the class hierarchy (and perhaps a dozen terms and their annotations).
- Review [release-to-merge diff (DrOn only)](https://www.dropbox.com/s/jia55otxatn71l9/dron-release-diff-merged.txt?dl=0). This is the most important diff, which contains _all axioms that actually involve DrOn classes_ that have changed between the current dron.owl release (from Bitbucket) and the merged form of the edit file (so essentially running `robot merge` on `src/ontology/dron-edit.owl`). This should be empty, or tiny. Currently, the only axiom in the diff head to be removed because of unsatisfiability (see [issue](https://github.com/matentzn/dron/issues/2)).
- Review [release-to-build diff (DrOn only)](https://www.dropbox.com/s/vo1s8ehtizdmp5a/dron-release-diff-build.txt?dl=0) (only elements that actually involve DrOn classes). This is already considerably larger, containing all axioms that have changed between the current dron.owl release (from Bitbucket) and the _ODK-released_ version of DrOn. It is worth cherry picking some axioms from the diff and checking them in Protege (open dron-edit.owl in Protege and run Elk reasoner). See above section on inference and imports in ODK-based dron.owl.

### Instructions for in-depth review
- Review [release-to-merge diff (non DrOn (external stuff))](https://www.dropbox.com/s/8pt56w13o9dgzu8/release-diff-merged.txt?dl=0). This is a huge diff including axioms that are due to changes in imported ontologies. Of the roughly 99% of these changes are due to the refreshed CHEBI import (80K changes). We believe its worth trying to identify patterns in these changes, like missing properties. Not that this is using the exact same config as OMRSE, so Matt D. should be quite familiar reviewing these.
- Review [release-to-build diff (non DrOn (external stuff)](https://www.dropbox.com/s/2z7eiv11k0ago11/release-diff-build.txt?dl=0). This (equally huge) diff includes all non-DrOn axioms that have changed between the current dron.owl release (from Bitbucket) and the _ODK-released_ version of DrOn. This is 99% redundant with the above release-to-merge diff, so we recommend to disregard it.
- Become aware of issues we noticed during the work:
    - [Has-proper-part and has-part usage Dron not compatible with RO](https://github.com/matentzn/dron/issues/3)
    - [Dron uses BFO:0000053 which is neither in RO nor BFO](https://github.com/matentzn/dron/issues/1)
- Close the unsatisfiable classes [issue](https://github.com/matentzn/dron/issues/2).