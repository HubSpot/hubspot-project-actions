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

This guide walks through setting up a new workflow file that automatically uploads new changes on your `main` branch to your HubSpot account.

1. In your project, create a GitHub Action workflow file at `.github/workflows/main.yml`
2. Copy the following example workflow into your `main.yml` file.

```yaml
on:
  push:
    branches:
      - main
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2.3.3
      - name: HubSpot CLI Install
        uses: HubSpot/hubspot-project-actions/install-cli@v1.0
      - name: HubSpot Project Upload Action
        uses: HubSpot/hubspot-project-actions/project-upload@v1.0
        with:
          account_id: ${{ secrets.hubspot_account_id }}
          personal_access_key: ${{ secrets.hubspot_personal_access_key }}
```

4. Commit and merge your changes

_Note:_ Do not change the `account_id` or `personal_access_key` values in your workflow. Auth related values should only be stored as GitHub secrets.

This should enable automatic uploads to your target HubSpot account with every commit into `main` 🚀
