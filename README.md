# Official HubSpot Project Actions

:warning: This is pre-release software. It is unstable and subject to breaking changes.

For now, we recommend using the more stable [current project upload action](https://github.com/HubSpot/hubspot-project-upload-action)

---

Use these composable actions to upload, deploy, and test your HubSpot Developer Projects. These actions are modular so you can arrange them into a workflow that best suits your needs.

Don't know where to start? Follow the usage guide below to set up a basic flow to upload your project into your HubSpot account.

## Basic usage - Uploading your project

In your GitHub repo, create two new [secrets](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository) for:

- `HUBSPOT_ACCOUNT_ID` - This is your HubSpot account ID
- `HUBSPOT_PERSONAL_ACCESS_KEY` - Your [personal access key](https://developers.hubspot.com/docs/cms/personal-cms-access-key)

The recommended way to leverage these in your actions is to set them as environment variables at the workflow level:

```yaml
env:
  DEFAULT_ACCOUNT_ID: ${{ secrets.HUBSPOT_ACCOUNT_ID }}
  DEFAULT_PERSONAL_ACCESS_KEY: ${{ secrets.HUBSPOT_PERSONAL_ACCESS_KEY }}
  DEFAULT_CLI_VERSION: "latest" # Optional: specify a CLI version (it will default to latest if unset)
```

Now, set up a new workflow file that automatically uploads new changes on your `main` branch to your HubSpot account.

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

## `Test Hubspot Project` Action

This action is a wrapper around several core actions to simplify your workflow setup. It facilitates our recommended automated validation & testing workflow.

1. Validate your project to ensure it's properly configured
2. Create a new Developer Test Account to test in isolation
3. Upload your project into the test account and install your app

This sets you up with an isolated environment to safely run your tests!

See the [test-hubspot-project docs](./test-hubspot-project/README.md) for details on how to use this action in your workflow.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/test-hubspot-project@v1
  with:
    account_config_path: "./test-account-config.json"
    project_dir: "./my-project" # optional
```

## Available Actions

While we recommend using our `test-hubspot-project` action, you are free to compose these actions however you'd like! All actions support the `DEFAULT_ACCOUNT_ID` and `DEFAULT_PERSONAL_ACCESS_KEY` env variables, so you don't need to pass them into each action individually.

### `Create Test Account`

Creates a new HubSpot test account based on a configuration file. This action allows you to programmatically create test accounts with predefined settings.

See the [create-test-account docs](./create-test-account/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/create-test-account@v1
  with:
    account_config_path: "./test-account-config.json"
```

### `Delete Test Account`

Deletes a HubSpot test account. This action is typically used to clean up test accounts after running tests.

See the [delete-test-account docs](./delete-test-account/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/delete-test-account@v1
  with:
    personal_access_key: ${{ steps.create-test-account.outputs.personal_access_key }}
    account_id: ${{ steps.create-test-account.outputs.account_id }}
```

### `Project Upload`

Uploads and builds a HubSpot project in your account. If auto-deploy is enabled, the build will also be deployed to your account.

See the [project-upload docs](./project-upload/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-upload@v1
  with:
    project_dir: "./my-project" # optional
```

### `Project Deploy`

Deploys a specific build of a HubSpot project.

See the [project-deploy docs](./project-deploy/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-deploy@v1
  with:
    build_id: ${{ steps.upload-action-step.outputs.build_id }}
    project_dir: "./my-project" # optional
```

### `Project Validate`

Validates the configuration of a HubSpot project.

See the [project-validate docs](./project-validate/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-validate@v1
  with:
    project_dir: "./my-project" # optional
```

### `Install OAuth App`

Installs your project's OAuth app into a target Developer Test Account.

See the [install-oauth-app docs](./install-oauth-app/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/install-oauth-app@v1
  with:
    target_account_id: 12345678
```

### `Install HubSpot CLI`

Installs the HubSpot CLI. Only installs if the cli has not already been installed by an earlier step.

See the [install-hubspot-cli docs](./install-hubspot-cli/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/install-hubspot-cli@v1
  with:
    cli_version: "7.0.0"
```
