# Official HubSpot Project Actions

Composable workflow actions to upload, deploy, and validate your HubSpot Developer Projects 🚀

## Basic usage - Uploading your project using our default action

In your GitHub repo, create two new [secrets](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository) for:

- `HUBSPOT_ACCOUNT_ID` - This is your HubSpot account ID
- `HUBSPOT_PERSONAL_ACCESS_KEY` - Your [personal access key](https://developers.hubspot.com/docs/cms/personal-cms-access-key)

The recommended way to leverage these in your actions is to set them as environment variables at the workflow level:

```yaml
env:
  DEFAULT_ACCOUNT_ID: ${{ secrets.HUBSPOT_ACCOUNT_ID }}
  DEFAULT_PERSONAL_ACCESS_KEY: ${{ secrets.HUBSPOT_PERSONAL_ACCESS_KEY }}
  DEFAULT_CLI_VERSION: "8.0.0" # Optional: specify a CLI version (it will default to a stable version).
```

**TIP:** The `DEFAULT_CLI_VERSION` will default to a specific stable version.  If the `DEFAULT_CLI_VERSION` is used, we recommend targeting a specific cli version instead of using dist-tags like "latest" or "next" to prevent new releases from impacting your CI/CD flow.

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
        uses: actions/checkout@v4
      - name: HubSpot Project Action
        uses: HubSpot/hubspot-project-actions@v1.0.1
```

3. Commit and merge your changes

**Important!** Do not change the `account_id` or `personal_access_key` values in your workflow. Auth related values should only be stored as GitHub secrets.

This should enable automatic uploads to your target HubSpot account with every commit into `main` 🎉

## Using with HubSpot Project Profiles

If your HubSpot project uses [config profiles](https://developers.hubspot.com/docs/developer-tooling/local-development/build-with-config-profiles) to manage multiple environments, you'll need to configure your actions to specify which profile to target. Profiles allow you to deploy the same project to different HubSpot accounts (e.g., development, staging, production) with environment-specific configurations.

Each profile targets a different HubSpot account, so you'll need to configure separate credentials for each environment:

#### 1. Set up GitHub Secrets for Each Profile

For each profile you want to use in your CI/CD workflows, create a corresponding set of secrets:

- For a `qa` profile targeting account `12345`:
  - `HUBSPOT_QA_ACCOUNT_ID` = `12345`
  - `HUBSPOT_QA_PERSONAL_ACCESS_KEY` = `[personal access key for account 12345]`

- For a `prod` profile targeting account `67890`:
  - `HUBSPOT_PROD_ACCOUNT_ID` = `67890`
  - `HUBSPOT_PROD_PERSONAL_ACCESS_KEY` = `[personal access key for account 67890]`

**Note:** The personal access key must be generated for the specific HubSpot account that the profile targets.

#### 2. Configure Your Workflow

Use the profile-specific secrets and pass the `profile` parameter to the action:

```yaml
on:
  push:
    branches:
      - main

jobs:
  deploy-qa:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Upload to QA
        uses: HubSpot/hubspot-project-actions/project-upload@v1.0.1
        with:
          profile: "qa"
          account_id: ${{ secrets.HUBSPOT_QA_ACCOUNT_ID }}
          personal_access_key: ${{ secrets.HUBSPOT_QA_PERSONAL_ACCESS_KEY }}
```
**Important:** All actions (`project-upload`, `project-deploy`, `project-validate`) support the `profile` parameter. When using profiles, you must pass the profile-specific credentials to each action.

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

- `HubSpot/hubspot-project-actions@v1.0.1`
- `HubSpot/hubspot-project-actions/project-upload@v1.0.1`
- `HubSpot/hubspot-project-actions/project-deploy@v1.2.3`
- `HubSpot/hubspot-project-actions/project-validate@v2.0.0`

## Available Actions

All actions support the `DEFAULT_ACCOUNT_ID`, `DEFAULT_PERSONAL_ACCESS_KEY`, `DEFAULT_CLI_VERSION`, and `DEFAULT_DEBUG` env variables. There's no need to pass them into each action individually as inputs.

**TIP:** Set `DEFAULT_DEBUG: true` or pass `debug: true` to any action to enable verbose CLI output. This is useful for troubleshooting failures.

### `Project Upload`

Uploads and builds a HubSpot project in your account. If auto-deploy is enabled, the build will also be deployed to your account.

See the [project-upload docs](./project-upload/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-upload@v1.0.1
  with:
    project_dir: "./my-project" # optional
```

### `Project Deploy`

Deploys a specific build of a HubSpot project.

See the [project-deploy docs](./project-deploy/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-deploy@v1.0.1
  with:
    build_id: ${{ steps.upload-action-step.outputs.build_id }}
    project_dir: "./my-project" # optional
```

### `Project Validate`

Validates the configuration of a HubSpot project.

See the [project-validate docs](./project-validate/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/project-validate@v1.0.1
  with:
    project_dir: "./my-project" # optional
```

### `Install HubSpot CLI`

Installs the HubSpot CLI. Only installs if the cli has not already been installed by an earlier step.

See the [install-hubspot-cli docs](./install-hubspot-cli/README.md) for detailed specs.

**Example usage:**

```yaml
- uses: HubSpot/hubspot-project-actions/install-hubspot-cli@v1.0.1
  with:
    cli_version: "8.0.0"
```
