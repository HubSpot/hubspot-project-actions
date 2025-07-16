# `Project Upload` Action

Uploads and builds a HubSpot project in your account. If auto-deploy is enabled, the build will also be deployed to your account.

**Inputs:**

- `project_dir` (optional): The path to the directory where your hsproject.json file is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will use DEFAULT_CLI_VERSION from environment.

**Outputs:**

- `build_id`: The build ID of the created HubSpot project build
- `deploy_id`: The deploy ID of the initiated HubSpot project deploy. This is only set if auto-deploy is enabled for your project.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-upload@v1
  with:
    project_dir: "./my-project" # optional
```
