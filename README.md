# HubSpot Project Actions

:warning: This is pre-release software. It is unstable and subject to breaking changes.

For now, we recommend using the [current project upload action](https://github.com/HubSpot/hubspot-project-upload-action)

## Official HubSpot Project Actions

Use these composable actions to upload, deploy, and test your Developer Projects in HubSpot. These actions are modular so you can organize them into a flow that best suits your needs.

Don't know where to start? Follow the usage guide below to set up a basic CI/CD flow. The actions available in this repo will enable you to kick off the following flow on every commit into your default branch:

1. Spin up a new test account for isolated testing
2. Upload your project into the new account
3. Install your application into the new account
4. Run tests against the app in your test account
5. Tear down the test account
6. Deploy the validated project to your production account

## Basic Usage: uploading your project

In your GitHub repo, create two new [secrets](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository) for:

- `HUBSPOT_ACCOUNT_ID` - This is your HubSpot account ID
- `HUBSPOT_PERSONAL_ACCESS_KEY` - Your [personal access key](https://developers.hubspot.com/docs/cms/personal-cms-access-key)

Alternatively, you can set these as environment variables at the workflow level:

```yaml
env:
  DEFAULT_ACCOUNT_ID: ${{ secrets.HUBSPOT_ACCOUNT_ID }}
  DEFAULT_PERSONAL_ACCESS_KEY: ${{ secrets.HUBSPOT_PERSONAL_ACCESS_KEY }}
  DEFAULT_CLI_VERSION: "latest" # Optional: specify a CLI version (it will default to latest if unset)
```

This guide walks through setting up a new workflow file that automatically uploads new changes on your `main` branch to your HubSpot account.

1. In your project, create a GitHub Action workflow file at `.github/workflows/main.yml`
2. Copy the following example workflow into your `main.yml` file.

**Note:** Replace `- main` with your default branch name if it's something other than `main`

```yaml
on:
  push:
    branches:
      - main
env:
  DEFAULT_ACCOUNT_ID: ${{ secrets.HUBSPOT_ACCOUNT_ID }}
  DEFAULT_PERSONAL_ACCESS_KEY: ${{ secrets.HUBSPOT_PERSONAL_ACCESS_KEY }}
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2.3.3
      - name: HubSpot Project Upload Action
        uses: HubSpot/hubspot-project-actions/project-upload@v1.0
```

3. Commit and merge your changes

**Important!** Do not change the `account_id` or `personal_access_key` values in your workflow. Auth related values should only be stored as GitHub secrets.

This should enable automatic uploads to your target HubSpot account with every commit into `main` 🚀

## Available Actions

### `create-test-account`

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

### `delete-test-account`

Deletes a HubSpot test account. This action is typically used to clean up test accounts after running tests.

**Inputs:**

- `personal_access_key` (optional): Personal Access Key of the test account to be deleted. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): Account ID of the test account to be deleted. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will use DEFAULT_CLI_VERSION from environment.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/delete-test-account@v1
  with:
    personal_access_key: ${{ steps.create-test-account.outputs.personal_access_key }}
    account_id: ${{ steps.create-test-account.outputs.account_id }}
```

### `Project Upload`

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

### `Project Deploy`

Deploys a specific build of a HubSpot project.

**Inputs:**

- `build_id` (required): Build ID to deploy
- `project_dir` (optional): Directory where hsproject.json is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will use DEFAULT_CLI_VERSION from environment.

**Outputs:**

- `deploy_id`: The deploy ID of the initiated HubSpot project deploy

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-deploy@v1
  with:
    build_id: ${{ steps.upload.outputs.build_id }}
    project_dir: "./my-project" # optional
```

### `Project Validate`

Validates the configuration of a HubSpot project.

**Inputs:**

- `project_dir` (optional): The path to the directory where your hsproject.json file is located. Defaults to "./"
- `personal_access_key` (optional): Personal Access Key generated in HubSpot that grants access to the CLI. If not provided, will use DEFAULT_PERSONAL_ACCESS_KEY from environment.
- `account_id` (optional): HubSpot account ID associated with the personal access key. If not provided, will use DEFAULT_ACCOUNT_ID from environment.
- `cli_version` (optional): Version of the HubSpot CLI to install. If not provided, will use DEFAULT_CLI_VERSION from environment.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-validate@v1
  with:
    project_dir: "./my-project" # optional
```
