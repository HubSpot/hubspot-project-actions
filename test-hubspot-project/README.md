# `Test Hubspot Project` Action

Test a HubSpot project using our recommended workflow. This action will validate your project, create a test account, upload your project, and then install the OAuth app.

**Inputs:**

- `account_config_path` (required): The path to the account config file to use for the test account
- `project_dir` (required): The path to the directory where your hsproject.json file is located. Defaults to `./`
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal-access-key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will look for `DEFAULT_CLI_VERSION` in environment. If neither are found, defaults to `latest`.

**Outputs:**

- `test_account_id`: The account ID of the test account created for the project
- `auth_code`: The auth code for the installed OAuth app

**Example usage:**

On every code push, initiate a full testing workflow. Add any of your own testing steps to the deploy job after the `test-hubspot-project` action finishes setting up your environment. Then, cleanup your test account.

```yaml
on: [push]

env:
  DEFAULT_ACCOUNT_ID: ${{ secrets.HUBSPOT_ACCOUNT_ID }}
  DEFAULT_PERSONAL_ACCESS_KEY: ${{ secrets.HUBSPOT_PERSONAL_ACCESS_KEY }}
  DEFAULT_CLI_VERSION: 7.0.0

jobs:
  deploy:
    runs-on: ubuntu-latest
    outputs:
      test_account_id: ${{ steps.test-hubspot-project-step.outputs.test_account_id }}
    steps:
      - name: Checkout
        uses: actions/checkout@v2.3.3
      - name: Test HubSpot Project
        id: test-hubspot-project-step
        uses: HubSpot/hubspot-project-actions/test-hubspot-project@v1
        with:
          account_config_path: "./test-account-config.json"
          project_dir: "./my-project" # optional

  # We recommend cleaning up the created test account after the tests run
  cleanup:
    needs: deploy
    if: always() && needs.deploy.outputs.test_account_id != ''
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2.3.3
      - name: HubSpot Delete Test Account Action
        uses: HubSpot/hubspot-project-actions/delete-test-account@v1
        with:
          test_account_id: ${{ needs.deploy.outputs.test_account_id }}
```
