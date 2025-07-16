# `Delete Test Account` Action

Deletes a HubSpot test account. This action is typically used to clean up test accounts after running tests.

**Inputs:**

- `personal_access_key` (optional): Personal Access Key of the test account to be deleted. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): Account ID of the test account to be deleted. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will use DEFAULT_CLI_VERSION from environment.

**Outputs:**
No outputs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/delete-test-account@v1
  with:
    personal_access_key: ${{ steps.create-test-account-step.outputs.personal_access_key }}
    account_id: ${{ steps.create-test-account-step.outputs.account_id }}
```
