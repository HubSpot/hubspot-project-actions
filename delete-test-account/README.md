# `Delete Test Account` Action

Deletes a HubSpot test account. This action is typically used to clean up test accounts after running tests.

**Inputs:**

- `personal_access_key` (optional): Personal Access Key of the test account to be deleted. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): Account ID of the test account to be deleted. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will use DEFAULT_CLI_VERSION from environment.

**Outputs:**
No outputs.

**Example usage:**

On every code push, create a new test account. Then delete it in the cleanup job. This will only attempt to cleanup the account if it was successfully created. It leverages the `account_id` output from the test account create action, and makes it available in the cleanup job by declaring it as output of the deploy job.

```yaml
on: [push]

env:
  DEFAULT_PERSONAL_ACCESS_KEY: ${{ secrets.HUBSPOT_PERSONAL_ACCESS_KEY }}
  DEFAULT_ACCOUNT_ID: ${{ secrets.HUBSPOT_ACCOUNT_ID }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    outputs:
      test_account_id: ${{ steps.test-account-create-step.outputs.account_id }}
    steps:
      - name: Checkout
        uses: actions/checkout@v2.3.3
      - name: HubSpot Create Test Account
        id: test-account-create-step
        uses: HubSpot/hubspot-project-actions/create-test-account@v1
        with:
          account_config_path: ./test-account-config.json

  cleanup:
    needs: deploy
    if: always() && needs.deploy.outputs.test_account_id != ''
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2.3.3
      - name: HubSpot Delete Test Account
        uses: HubSpot/hubspot-project-actions/delete-test-account@v1
        with:
          test_account_id: ${{ needs.deploy.outputs.test_account_id }}
```
