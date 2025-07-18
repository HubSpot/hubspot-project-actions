# `Create Test Account` Action

Creates a new HubSpot test account based on a configuration file. This action allows you to programmatically create test accounts with predefined settings.

**Inputs:**

- `account_config_path` (required): Path to the test account configuration file
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will look for `DEFAULT_CLI_VERSION` in environment. If neither are found, defaults to `latest`.

**Outputs:**

- `personal_access_key`: The personal access key of the created test account
- `account_id`: The account ID of the created test account

**Example usage:**

On every code push, create a new test account and then upload your project into it. This leverages the `personal_access_key` and `account_id` output from the test account create action to upload the project into the newly created test account instead of the default account.

_tip:_ Use `hs test-account create-config` to generate a test account config file.

```yaml
on: [push]

env:
  DEFAULT_PERSONAL_ACCESS_KEY: ${{ secrets.HUBSPOT_PERSONAL_ACCESS_KEY }}
  DEFAULT_ACCOUNT_ID: ${{ secrets.HUBSPOT_ACCOUNT_ID }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2.3.3
      - name: HubSpot Create Test Account
        id: test-account-create-step
        uses: HubSpot/hubspot-project-actions/create-test-account@v1
        with:
          account_config_path: ./test-account-config.json
      - name: HubSpot Project Upload
        uses: HubSpot/hubspot-project-actions/project-upload@v1
        with:
          project_dir: ./my-project # optional
          personal_access_key: ${{ steps.test-account-create-step.outputs.personal_access_key }}
          account_id: ${{ steps.test-account-create-step.outputs.account_id }}
```
