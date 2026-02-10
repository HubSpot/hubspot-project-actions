# `Project Upload` Action

Uploads and builds a HubSpot project in your account. If auto-deploy is enabled, the build will also be deployed to your account.

**Inputs:**

- `project_dir` (optional): The path to the directory where your hsproject.json file is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will look for `DEFAULT_CLI_VERSION` in environment. If neither are found, defaults to `latest`.
- `profile` (optional): Profile to use for the HubSpot CLI. If not provided, will use DEFAULT_PROFILE from environment.
- `debug` (optional): Enable debug mode for verbose CLI output. Useful for troubleshooting upload failures. If not provided, will use DEFAULT_DEBUG from environment. Defaults to `false`.

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
        uses: actions/checkout@v4
      - name: HubSpot Project Upload
        uses: HubSpot/hubspot-project-actions/project-upload@v1.1.0
        with:
          project_dir: "./my-project" # optional
```

**Example with profiles:**

If your project uses [config profiles](https://developers.hubspot.com/docs/developer-tooling/local-development/build-with-config-profiles), specify the profile and corresponding credentials:

```yaml
on:
  push:
    branches:
      - main

jobs:
  upload-to-qa:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Upload to QA Environment
        uses: HubSpot/hubspot-project-actions/project-upload@v1.1.0
        with:
          profile: "qa"
          account_id: ${{ secrets.HUBSPOT_QA_ACCOUNT_ID }}
          personal_access_key: ${{ secrets.HUBSPOT_QA_PERSONAL_ACCESS_KEY }}
          project_dir: "./my-project"
```

**Note:** When using profiles, ensure you've created GitHub secrets for each profile's account credentials (e.g., `HUBSPOT_QA_ACCOUNT_ID` and `HUBSPOT_QA_PERSONAL_ACCESS_KEY`). See the [main documentation](../README.md#using-with-hubspot-project-profiles) for more details.
