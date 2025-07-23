# Releasing HubSpot Project Actions

This project uses semantic versioning with Git tags. Here's how to create a new release:

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

```bash
# Create an annotated tag
git tag -a v1.0.0 -m "Release v1.0.0"

# Push the tag to the remote repository
git push origin v1.0.0
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
