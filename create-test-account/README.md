# `Create Test Account` Action

Creates a new HubSpot test account based on a configuration file. This action allows you to programmatically create test accounts with predefined settings.

**Inputs:**

- `account_config_path` (required): Path to the test account configuration file
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will use DEFAULT_CLI_VERSION from environment.

**Outputs:**

- `personal_access_key`: The personal access key of the created test account
- `account_id`: The account ID of the created test account

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/create-test-account@v1
  with:
    account_config_path: "./test-account-config.json"
```
