# Releasing HubSpot Project Actions

This project uses semantic versioning with Git tags. Here's how to create a new release:

**IMPORTANT** Remember to update the references to the install cli action within the other actions

#### 1. Prepare for Release

Before creating a release, ensure:

- All changes are merged to the main branch
- Tests are passing
- Documentation is up to date
- You're on the main branch and it's up to date

```bash
git checkout main
git pull origin main
```

#### 2. Create a Release Tag

Use semantic versioning to determine the appropriate version number:

- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes

Create and push the tag:

Before you create the tag...
- Check out a new branch for the release
- Make sure to update any version references in the actions
- Commit your local changes

Use our scripts to handle versioning
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

### Rollback a Release

If you need to rollback a release (use with caution):

```bash
# Delete the tag locally
git tag -d v1.0.0

# Delete the tag from remote
git push origin --delete v1.0.0
```

**Note:** Rolling back a release can cause issues for users who are already using that version. Only do this if absolutely necessary and communicate the change to users.

### Best Practices

1. **Always use semantic versioning** - Follow the MAJOR.MINOR.PATCH format
2. **Write descriptive tag messages** - Include what changed in the release
3. **Test before releasing** - Ensure all functionality works as expected
4. **Document changes** - Update README and documentation as needed
5. **Communicate breaking changes** - Clearly document any incompatible changes
