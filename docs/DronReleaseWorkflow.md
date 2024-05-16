# Dron Release Workflow

To create a new Dron release:

1. [Update the components](#Update-the-components)
2. [Build the release files](#Build-the-release-files-and-create-a-GitHub-release)
3. [Create a GitHub release](#Build-the-release-files-and-create-a-GitHub-release)

## Update the components

DrOn has three components:

1. dron-rxnorm
2. dron-ndc
3. dron-ingredient

They are generated from the templates in `src/templates/`.
The templates are updated from RxNorm monthly releases.

TODO: RxNorm updates are not implemented in this version of the code.
That functionality will be added soon!

Build them with the `all_components` task:

```
cd dron/src/ontology
sh run.sh make all_components -B
```

The files will be created in `src/ontology/components/` and will be imported into `dron-edit.owl`.

## 2+3. Build the release files and create a GitHub release

Follow the [default ODK release instructions](odk-workflows/ReleaseWorkflow.md).

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



