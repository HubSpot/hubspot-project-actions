# `Project Deploy` Action

Deploys a specific build of a HubSpot project.

**Inputs:**

- `build_id` (required): Build ID to deploy
- `project_dir` (optional): The path to the directory where your hsproject.json file is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will use DEFAULT_CLI_VERSION from environment.

**Outputs:**

- `deploy_id`: The deploy ID of the initiated HubSpot project deploy

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-deploy@v1
  with:
    build_id: ${{ steps.upload-action-step.outputs.build_id }}
    project_dir: "./my-project" # optional
```
