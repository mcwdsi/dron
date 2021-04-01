# Dron Release Workflow

To create a new Dron release:

1. [Update the external components](UpdateComponents.md)
2. Import the external components
3. Build the release files
4. Create a GitHub release

## 1. Update the external components
DrOn has three large external components:

1. dron-rxnorm
2. dron-ndc
3. dron-ingredient

Due to their size, they are not in GitHub version control. 

The process of preparing a release works as follows:
1. Build the components using the DrOn builder application (as of 2021, done by Matt McConnell).
2. Upload the components to their s3 bucket. *Important: After the upload, all three components must be available from the following locations*:
   - https://drugontology.s3.amazonaws.com/dron-ingredient.owl
   - https://drugontology.s3.amazonaws.com/dron-ndc.owl
   - https://drugontology.s3.amazonaws.com/dron-rxnorm.owl
3. (If the location has to change, make sure that update the `DRON_RELEASE_LOCATION` variable in `src/ontology/dron.Makefile` before running an ODK release.)

The Dron Builder code is currently still bundled in a Scala module managed by Matt McConnell. 

## Import the external components

Before running the normal ODK release workflow, the release manager (as of 2021, Bill Hogan) has to download the components into their local DrOn repo. This is achieved as follows:

1. In your Terminal, go to your DrOn edit directory, for example:

```
cd dron/src/ontology
```

2. To download the external components previously uploaded to their s3 bucket: 

```
sh run.sh make download_components
```

This command will now download dron-ingredient.owl, dron-ndc.owl, dron-rxnorm.owl to your local machine (and overwrite any old versions of these three files), so that the ODK will recognise them as part of the upcoming release.

## 3+4. Build the release files and create a GitHub release

Follow the [default ODK release instructions](odk-workflows/ReleaseWorkflow.md).
