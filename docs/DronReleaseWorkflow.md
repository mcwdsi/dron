# Dron Release Workflow

To create a new Dron release:

1. [Create a Branch](#Create-a-Branch)
2. [Fetch RxNorm](#Fetch-RxNorm)
3. [Update Labels](#Update-Labels)
5. [Update Templates](#Update-Templates))
4. [Update Components](#Update-Components)
5. [Run ODK Workflow](#Run-ODK-Workflow)

Steps 3 and 4 should be repeated for each monthly RxNorm release, without skipping any months.

## 1. Create a Branch

Starting from an up-to-date copy of the `main` branch, without any uncommitted changes, create a new branch for this release. The branch is usually named for today's date:

```sh
cd src/ontology
git checkout main
git pull
git checkout -b release-YYYY-MM-DD
```

Note: You do not need to create a new branch in the ODK workflow steps -- this branch serves that purpose.

## 2. Fetch RxNorm

DrOn translates RxNorm data into ontological form. RxNorm publishes its data in monthly releases. The first step in updating DrOn is to fetch the next monthly release of RxNorm. It's important not to skip any months.

The `src/scripts/fetch-rxnorm.sh` script will fetch an RxNorm monthly release file, save it to `src/ontolgy/tmp/rxnorm/`, and unzip the relevant RRF files. The script requires the full date of the RxNorm release file and an API key. For the rest of this document, "MMDDYYY" refers to the date of the RxNorm release file being processed.

1. Find the full date of the RxNorm release at <https://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnormfiles.html>
2. Log in to your UMLS account and access your profile at <https://uts.nlm.nih.gov/uts/edit-profile>
3. Copy your API key
4. Run the script:

```sh
sh run.sh /work/src/scripts/fetch-rxnorm.sh MMDDYYY YOUR_API_KEY
```

## 3. Update Labels

DrOn uses term labels from RxNorm and ontology terms from ChEBI. Both these sources occasionally update their labels. The second step is to update the template files in `src/templates/` with any label changes:

```sh
sh run.sh make update-labels
```

You can inspect any changes to `src/templates/` using `git diff`. If there are changes, you may wish to commit them:

```sh
git diff --color-words ../templates/
git add -u ../templates/
git commit -m "Updated labels from RxNorm MMDDYYY and latest ChEBI"
```

## 4. Update Templates

Most of the content of DrOn is contained in the `src/templates/` files, and most of these are generated from the RxNorm release files.

```sh
sh run.sh make update-rxnorm
```

You will want to inspect changes using `git diff`. You should also look at a report of possible problems:

```sh
sh run.sh make tmp/problems.tsv
```

The report may suggest replacing DrOn ingredient terms with ChEBI terms. You can obsolete a DrOn term by adding it (with its replacement term) to `src/templates/obsolete.tsv` and running:

```sh
sh run.sh /work/src/scripts/obsolete-terms.sh
```

Once the templates look good, commit the changes:

```sh
git add -u ../templates/
git commit -m "Updated DrOn from RxNorm MMDDYYY"
```

Most DrOn releases contain updates from three months of RxNorm releases. Repeat steps 3 and 4 for each month, in order, and commit your changes.

## 5. Update Components

The `src/templates/` tables are used to generate three OWL components for DrOn:

1. dron-rxnorm
2. dron-ndc
3. dron-ingredient

Build them with the `all_components` task:

```
sh run.sh make all_components -B
```

The files will be created in `src/ontology/components/` and will be imported into `dron-edit.owl` whenever it is loaded.

## 6. Run ODK Workflow

Finally, follow the [default ODK release instructions](odk-workflows/ReleaseWorkflow.md) to make a full DrOn build and GitHub release.

### Experimental workflow using GitHub client API (`gh`)

- Install the GitHub release client API: https://github.com/cli/cli#installation. Note, this is a highly experimental process that requires a bit of pioneers spirit. When we did it on 7th April 2021, we performed the following steps on a Ubuntu machine (see [here](https://github.com/cli/cli#installation) for instructions on other systems):

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt-get install software-properties-common
sudo apt install gh
gh --version

OPTIONAL: git config --global user.name "Nico Matentzoglu" (use your own name)
OPTIONAL: git config --global user.email nicolas.matentzoglu@gmail.com (use your own email, the one that is associated with your GitHub account)

gh auth login
cd ../../
```

- This assumes you have already run the release, step 3 above.
- Run `gh release create v2021-04-02 dron*`, but make sure you use the correct date of the release (
This is not necessarily today - its the date you ran the ODK release pipeline. It can be seen form example in the Version IRI of dron-base.owl, or dron.owl. This will navigate you through a dialog, asking for title, and release notes. It is good to be familiar with the [default ODK release instructions](odk-workflows/ReleaseWorkflow.md) to understand what to write for each question. In essence, this is an _exact_ command line equivalent of the [manual version](odk-workflows/ReleaseWorkflow.md).
