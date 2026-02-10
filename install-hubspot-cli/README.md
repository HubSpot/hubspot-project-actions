# `Install HubSpot CLI` Action

Installs the HubSpot CLI. Only installs if the cli has not already been installed by an earlier step.

**Note:** All the HubSpot actions leverage this action. In most cases you shouldn't need to use this directly.

**Inputs:**

- `cli_version` (required): Version of the HubSpot CLI to install. If not provided, will look for `DEFAULT_CLI_VERSION` in environment. If neither are found, defaults to a pre-determined stable version of the CLI.

**Outputs:**
No outputs.

**Example usage:**

On every code push, install the HubSpot CLI.

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
        uses: actions/checkout@v4
      - name: Install HubSpot CLI Action
        uses: HubSpot/hubspot-project-actions/install-hubspot-cli@v1.0.1
        with:
          cli_version: "8.0.0"
```
