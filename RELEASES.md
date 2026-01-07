# Releasing HubSpot Project Actions

This project uses semantic versioning with Git tags. Here's how to create a new release:

**IMPORTANT** Remember to update the references to the install cli action within the other actions

## 1. Prepare for Release

Before creating a release, ensure:

- All changes are merged to the main branch
- Tests are passing
- Documentation is up to date
- You're on the main branch, and it's up to date.

```bash
git checkout main
git pull origin main
```

### 1.a Determine what the new version will be
Use semantic versioning to determine the appropriate version number:

- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes

### 1.b Update version references
Once you have determined what the new version will be, you will need to update any version references in the actions themselves. So create a branch and 
update the version in the `uses` keys in both the .yml files and the examples in the README.md files.  

They will look like this:

```yaml
    uses: HubSpot/hubspot-project-actions/project-upload@version
```

Once those all have been updated, open a PR to `main` and get it approved and merge it.

## 2. Create a Release Tag
After your PR to update the versions is merged get the latest main changes again.

```bash
git checkout main
git pull origin main
```

Then you can use the `npm run version` script to create a new version.

```bash
# Show available commands
npm run version help

# List all the current versions (tags)
npm run version list

# Display the current version
npm run version current

# Show info for the current version
npm run version info

# Create a new version
npm run version create <version> [message]
```

### Delete the tag, if needed

If you need to delete the tag for some reason:

```bash
# Delete the tag locally
git tag -d vx.x.x

# Delete the tag from remote
git push origin --delete vx.x.x
```


## 3. Publish the release
Now that the tag exists, [create a release](https://github.com/HubSpot/hubspot-project-actions/releases/new) for the new version in the repo.  Once this is created, it will publish the new version in the marketplace.

**Note:** Rolling back a release can cause issues for users who are already using that version. Only do this if absolutely necessary and communicate the change to users.

### Best Practices

1. **Always use semantic versioning** - Follow the MAJOR.MINOR.PATCH format
2. **Write descriptive tag messages** - Include what changed in the release
3. **Test before releasing** - Ensure all functionality works as expected
4. **Document changes** - Update README and documentation as needed
5. **Communicate breaking changes** - Clearly document any incompatible changes
