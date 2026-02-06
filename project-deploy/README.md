# `Project Deploy` Action

Deploys a specific build of a HubSpot project.

**Inputs:**

- `build_id` (optional): Build ID to deploy [conflicts with deploy_latest_build]
- `deploy_latest_build`: (optional): Deploy the most recent build [conflicts with build_id]
- `project_dir` (optional): The path to the directory where your hsproject.json file is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will look for `DEFAULT_CLI_VERSION` in environment. If neither are found, defaults to a pre-determined stable version of the CLI.
- `profile` (optional): Profile to use for the HubSpot CLI. If not provided, will use DEFAULT_PROFILE from environment.
- `debug` (optional): Enable debug mode for verbose CLI output. Useful for troubleshooting deploy failures. If not provided, will use DEFAULT_DEBUG from environment. Defaults to `false`.

**Outputs:**

- `deploy_id`: The deploy ID of the initiated HubSpot project deploy

**Example usage:**

On every code push into the main branch, upload the project and then manually deploy the latest build. This leverages the `build_id` output from the upload action. This sequence will be necessary if your HubSpot project does not have auto-deploy enabled.

```yaml
on:
  push:
    branches:
      - main
env:
  DEFAULT_ACCOUNT_ID: ${{ secrets.HUBSPOT_ACCOUNT_ID }}
  DEFAULT_PERSONAL_ACCESS_KEY: ${{ secrets.HUBSPOT_PERSONAL_ACCESS_KEY }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: HubSpot Project Upload
        id: upload-step
        uses: HubSpot/hubspot-project-actions/project-upload@v1.0.1
        with:
          project_dir: "./my-project" # optional
      - name: HubSpot Project Deploy
        uses: HubSpot/hubspot-project-actions/project-deploy@v1.0.1
        with:
          build_id: ${{ steps.upload-step.outputs.build_id }}
          project_dir: "./my-project" # optional
```

**Example with profiles:**

If your project uses [config profiles](https://developers.hubspot.com/docs/developer-tooling/local-development/build-with-config-profiles), specify the profile and corresponding credentials for both upload and deploy:

```yaml
on:
  push:
    branches:
      - main

jobs:
  deploy-to-production:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Upload to Production
        id: upload-step
        uses: HubSpot/hubspot-project-actions/project-upload@v1.0.1
        with:
          profile: "prod"
          account_id: ${{ secrets.HUBSPOT_PROD_ACCOUNT_ID }}
          personal_access_key: ${{ secrets.HUBSPOT_PROD_PERSONAL_ACCESS_KEY }}
          project_dir: "./my-project"
      - name: Deploy to Production
        uses: HubSpot/hubspot-project-actions/project-deploy@v1.0.1
        with:
          profile: "prod"
          account_id: ${{ secrets.HUBSPOT_PROD_ACCOUNT_ID }}
          personal_access_key: ${{ secrets.HUBSPOT_PROD_PERSONAL_ACCESS_KEY }}
          build_id: ${{ steps.upload-step.outputs.build_id }}
          project_dir: "./my-project"
```

**Note:** When using profiles, ensure you've created GitHub secrets for each profile's account credentials (e.g., `HUBSPOT_PROD_ACCOUNT_ID` and `HUBSPOT_PROD_PERSONAL_ACCESS_KEY`). Both upload and deploy actions must use the same profile and credentials. See the [main documentation](../README.md#using-with-hubspot-project-profiles) for more details.
