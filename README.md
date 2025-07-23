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
        uses: HubSpot/hubspot-project-actions/project-upload@v1.0.0
```

3. Commit and merge your changes

**Important!** Do not change the `account_id` or `personal_access_key` values in your workflow. Auth related values should only be stored as GitHub secrets.

This should enable automatic uploads to your target HubSpot account with every commit into `main` 🚀

## Versioning

This repository uses semantic versioning with Git tags.

- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes

Actions can be referenced using the following format:

```
HubSpot/hubspot-project-actions/[action-name]@v[version]
```

For example:

- `HubSpot/hubspot-project-actions/project-upload@v1.0.0`
- `HubSpot/hubspot-project-actions/project-deploy@v1.2.3`
- `HubSpot/hubspot-project-actions/project-validate@v2.0.0`

## Available Actions

All actions support the `DEFAULT_ACCOUNT_ID` and `DEFAULT_PERSONAL_ACCESS_KEY` env variables, so you don't need to pass them into each action individually.

### `Project Upload`

Uploads and builds a HubSpot project in your account. If auto-deploy is enabled, the build will also be deployed to your account.

See the [project-upload docs](./project-upload/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-upload@v1.0.0
  with:
    project_dir: "./my-project" # optional
```

### `Project Deploy`

Deploys a specific build of a HubSpot project.

See the [project-deploy docs](./project-deploy/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-deploy@v1.0.0
  with:
    build_id: ${{ steps.upload-action-step.outputs.build_id }}
    project_dir: "./my-project" # optional
```

### `Project Validate`

Validates the configuration of a HubSpot project.

See the [project-validate docs](./project-validate/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-validate@v1.0.0
  with:
    project_dir: "./my-project" # optional
```

### `Install HubSpot CLI`

Installs the HubSpot CLI. Only installs if the cli has not already been installed by an earlier step.

See the [install-hubspot-cli docs](./install-hubspot-cli/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/install-hubspot-cli@v1.0.0
  with:
    cli_version: "7.0.0"
```
