# `Install OAuth App` Action

Installs your project's OAuth app into a target Developer Test Account.

**Inputs:**

- `test_account_id` (required): Account ID of the test account to install your app into.
- `project_dir` (optional): The path to the directory where your hsproject.json file is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will look for `DEFAULT_CLI_VERSION` in environment. If neither are found, defaults to `latest`.

**Outputs:**

- `authCode`: The access token returned by the app install

**Example usage:**

On every code push, create a new test account, upload your project into it, and then install your app into it. This leverages the `personal_access_key` and `account_id` output from the test account create action to upload the project into the newly created test account instead of the default account.

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
      - name: HubSpot Install App
        uses: HubSpot/hubspot-project-actions/install-app@v1
        with:
          test_account_id: ${{ steps.test-account-create-step.outputs.account_id }}
          project_dir: ./my-project # optional
          personal_access_key: ${{ steps.test-account-create-step.outputs.personal_access_key }}
          account_id: ${{ steps.test-account-create-step.outputs.account_id }}
```
