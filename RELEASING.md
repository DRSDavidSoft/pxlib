# Release Process

This document describes how to create a new release of pxlib.

## Prerequisites

- Write access to the repository
- All changes merged to the main/master branch
- Updated ChangeLog file

## Release Steps

### 1. Update Version Numbers

**Automated Method (Recommended):**

Use the version update script to automatically update all version numbers:

```bash
./scripts/update-version.sh X.Y.Z
```

This script will update:
- `VERSION` file (canonical version)
- `CMakeLists.txt` (MAJOR, MINOR, MICRO version variables)
- `configure.ac` (AC_INIT and version variables)

**Manual Method (Not Recommended):**

If you prefer to update manually, edit the following files:

- `VERSION`: Set the version to `X.Y.Z`
- `CMakeLists.txt`: Update `PXLIB_MAJOR_VERSION`, `PXLIB_MINOR_VERSION`, and `PXLIB_MICRO_VERSION`
- `configure.ac`: Update `AC_INIT` version parameter and individual version variables

**Note:** The build and release workflows will fail if version numbers are inconsistent across these files.

### 2. Verify Version Consistency

Run the version check script to ensure all versions are in sync:

```bash
./scripts/check-version.sh
```

This check is also run automatically in CI/CD and will fail the build if versions don't match.

### 2. Verify Version Consistency

Run the version check script to ensure all versions are in sync:

```bash
./scripts/check-version.sh
```

This check is also run automatically in CI/CD and will fail the build if versions don't match.

### 3. Update ChangeLog

Add a new entry to the `ChangeLog` file describing the changes in this release.

Example:
```
Version X.Y.Z
    - Feature: Added new functionality
    - Bug fix: Fixed issue with...
    - Improvement: Enhanced performance of...
```

### 4. Commit and Push Changes

```bash
git add VERSION CMakeLists.txt configure.ac ChangeLog
git commit -m "Release version X.Y.Z"
git push origin master
```

### 5. Create and Push Tag

Create a git tag with the version number (must start with 'v'):

```bash
git tag -a vX.Y.Z -m "Release version X.Y.Z"
git push origin vX.Y.Z
```

### 6. Automated Release

Once the tag is pushed, GitHub Actions will automatically:

1. **Verify version consistency** across all project files
2. **Verify tag matches VERSION file** (tag vX.Y.Z must match VERSION file X.Y.Z)
3. Build binaries for Linux (GCC and Clang), Windows, and macOS
4. Generate a changelog from git commit history
5. Create a GitHub Release
6. Upload build artifacts to the release

**Important:** The release workflow will fail if:
- Version numbers are inconsistent across files
- The git tag version doesn't match the VERSION file

The release workflow can be monitored at:
https://github.com/DRSDavidSoft/pxlib/actions/workflows/release.yml

### 7. Verify Release

After the workflow completes:

1. Go to https://github.com/DRSDavidSoft/pxlib/releases
2. Verify the release was created with the correct version
3. Check that all artifacts are attached:
   - `pxlib-linux-gcc.tar.gz` - Linux build with GCC
   - `pxlib-linux-clang.tar.gz` - Linux build with Clang
   - `pxlib-windows.zip` - Windows DLL
   - `pxlib-macos.tar.gz` - macOS shared library
4. Review the generated changelog

## Manual Release (Optional)

If needed, releases can also be triggered manually:

1. Go to https://github.com/DRSDavidSoft/pxlib/actions/workflows/release.yml
2. Click "Run workflow"
3. Enter the tag name (e.g., `v0.6.9`)
4. Click "Run workflow"

## Release Assets

Each release includes the following binary artifacts:

- **Linux (GCC)**: Shared library compiled with GCC
- **Linux (Clang)**: Shared library compiled with Clang
- **Windows**: DLL file for Windows
- **macOS**: Dynamic library for macOS

Users can download the appropriate artifact for their platform from the GitHub Releases page.

## Versioning Scheme

pxlib follows semantic versioning (MAJOR.MINOR.MICRO):

- **MAJOR**: Incompatible API changes
- **MINOR**: Backwards-compatible functionality additions
- **MICRO**: Backwards-compatible bug fixes

## Version Management Scripts

### check-version.sh

Validates that version numbers are consistent across all project files:
- `VERSION` file
- `CMakeLists.txt`
- `configure.ac`

Usage:
```bash
./scripts/check-version.sh
```

Exit code 0 if all versions match, 1 if inconsistencies are found.

### update-version.sh

Automatically updates version numbers in all project files:

Usage:
```bash
./scripts/update-version.sh X.Y.Z
```

This ensures version consistency and eliminates manual update errors.

## Troubleshooting

### Release workflow fails

1. Check the GitHub Actions logs for errors
2. Ensure all build jobs completed successfully
3. Verify that artifacts were uploaded correctly
4. Check that permissions are set correctly in the workflow

### Missing artifacts

If artifacts are missing from the release:

1. Check that the build jobs completed successfully
2. Verify the artifact upload patterns in the workflow
3. Check the artifact download step logs

### Changelog issues

The changelog is automatically generated from git commit history between tags. For better changelog quality:

- Write descriptive commit messages
- Use conventional commit format when possible
- Group related commits together
