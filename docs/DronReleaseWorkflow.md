# Dron Release Workflow

To create a new Dron release:

1. [Update the external components](#Update-the-external-components)
2. [Import the external components](#Import-the-external-components)
3. [Build the release files](#Build-the-release-files-and-create-a-GitHub-release)
4. [Create a GitHub release](#Build-the-release-files-and-create-a-GitHub-release)

## Update the external components
DrOn has three large external components:

1. dron-rxnorm
2. dron-ndc
3. dron-ingredient

Due to their size, they are not in GitHub version control. 

The process of preparing a release works as follows:

- Build the components using the DrOn builder application (as of 2021, done by Matt McConnell).
- Upload the components to their s3 bucket. *Important: After the upload, all three components must be available from the following locations*:
    - https://drugontology.s3.amazonaws.com/dron-ingredient.owl
    - https://drugontology.s3.amazonaws.com/dron-ndc.owl
    - https://drugontology.s3.amazonaws.com/dron-rxnorm.owl
- (If the location has to change, make sure that update the `DRON_RELEASE_LOCATION` variable in `src/ontology/dron.Makefile` before running an ODK release.)

The Dron Builder code is currently still bundled in a Scala module managed by Matt McConnell. 

## Import the external components

Before running the normal ODK release workflow, the release manager (as of 2021, Bill Hogan) has to download the components into their local DrOn repo. This is achieved as follows:

- In your Terminal, go to your DrOn edit directory, for example:

```
cd dron/src/ontology
```

- To download the external components previously uploaded to their s3 bucket: 

```
sh run.sh make download_components
```

This command will now download dron-ingredient.owl, dron-ndc.owl, dron-rxnorm.owl to your local machine (and overwrite any old versions of these three files), so that the ODK will recognise them as part of the upcoming release.

## 3+4. Build the release files and create a GitHub release

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



