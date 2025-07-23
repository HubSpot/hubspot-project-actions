# `Project Upload` Action

Uploads and builds a HubSpot project in your account. If auto-deploy is enabled, the build will also be deployed to your account.

**Inputs:**

- `project_dir` (optional): The path to the directory where your hsproject.json file is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will look for `DEFAULT_CLI_VERSION` in environment. If neither are found, defaults to `latest`.
- `profile` (optional): Profile to use for the HubSpot CLI. If not provided, will use DEFAULT_PROFILE from environment.

**Outputs:**

- `build_id`: The build ID of the created HubSpot project build
- `deploy_id`: The deploy ID of the initiated HubSpot project deploy. This is only set if auto-deploy is enabled for your project.

**Example usage:**

On every code push into the main branch, upload the project into the target account.

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
        uses: HubSpot/hubspot-project-actions/project-upload@v1
        with:
          project_dir: "./my-project" # optional
```
