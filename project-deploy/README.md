# `Project Deploy` Action

Deploys a specific build of a HubSpot project.

**Inputs:**

- `build_id` (required): Build ID to deploy
- `project_dir` (optional): The path to the directory where your hsproject.json file is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will look for `DEFAULT_CLI_VERSION` in environment. If neither are found, defaults to `latest`.

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
        uses: actions/checkout@v2.3.3
      - name: HubSpot Project Upload
        id: upload-step
        uses: HubSpot/hubspot-project-actions/project-upload@v1
        with:
          project_dir: "./my-project" # optional
      - name: HubSpot Project Deploy
        uses: HubSpot/hubspot-project-actions/project-deploy@v1
        with:
          build_id: ${{ steps.upload-step.outputs.build_id }}
          project_dir: "./my-project" # optional
```
