# Update Components

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