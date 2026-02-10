# `Project Validate` Action

Validates the configuration of a HubSpot project.

**Inputs:**

- `project_dir` (optional): The path to the directory where your hsproject.json file is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will look for `DEFAULT_CLI_VERSION` in environment. If neither are found, defaults to a pre-determined stable version of the CLI.
- `profile` (optional): Profile to use for the HubSpot CLI. If not provided, will use DEFAULT_PROFILE from environment.
- `debug` (optional): Enable debug mode for verbose CLI output. Useful for troubleshooting validation failures. If not provided, will use DEFAULT_DEBUG from environment. Defaults to `false`.

**Outputs:**

No outputs.

**Example usage:**

On every code push, validate the project.

```yaml
on: [push]

env:
  DEFAULT_ACCOUNT_ID: ${{ secrets.HUBSPOT_ACCOUNT_ID }}
  DEFAULT_PERSONAL_ACCESS_KEY: ${{ secrets.HUBSPOT_PERSONAL_ACCESS_KEY }}

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: HubSpot Project Validation
        uses: HubSpot/hubspot-project-actions/project-validate@v1.1.0
        with:
          project_dir: "./my-project" # optional
```

**Example with profiles:**

If your project uses [config profiles](https://developers.hubspot.com/docs/developer-tooling/local-development/build-with-config-profiles), you can validate against a specific profile:

```yaml
on: [push]

jobs:
  validate-staging:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Validate Staging Configuration
        uses: HubSpot/hubspot-project-actions/project-validate@v1.1.0
        with:
          profile: "staging"
          account_id: ${{ secrets.HUBSPOT_STAGING_ACCOUNT_ID }}
          personal_access_key: ${{ secrets.HUBSPOT_STAGING_PERSONAL_ACCESS_KEY }}
          project_dir: "./my-project"
```

**Note:** When using profiles, ensure you've created GitHub secrets for each profile's account credentials (e.g., `HUBSPOT_STAGING_ACCOUNT_ID` and `HUBSPOT_STAGING_PERSONAL_ACCESS_KEY`). See the [main documentation](../README.md#using-with-hubspot-project-profiles) for more details.
