# Release Process

This document describes how to create a new release of pxlib.

## Prerequisites

- Write access to the repository
- All changes merged to the main/master branch
- Updated ChangeLog file

## Release Steps

### 1. Update Version Numbers

Update the version number in the following files:

- `CMakeLists.txt`: Update `PXLIB_MAJOR_VERSION`, `PXLIB_MINOR_VERSION`, and `PXLIB_MICRO_VERSION`
- `configure.ac`: Update `AC_INIT` version parameter

### 2. Update ChangeLog

Add a new entry to the `ChangeLog` file describing the changes in this release.

Example:
```
Version X.Y.Z
    - Feature: Added new functionality
    - Bug fix: Fixed issue with...
    - Improvement: Enhanced performance of...
```

### 3. Commit and Push Changes

```bash
git add CMakeLists.txt configure.ac ChangeLog
git commit -m "Release version X.Y.Z"
git push origin master
```

### 4. Create and Push Tag

Create a git tag with the version number (must start with 'v'):

```bash
git tag -a vX.Y.Z -m "Release version X.Y.Z"
git push origin vX.Y.Z
```

### 5. Automated Release

Once the tag is pushed, GitHub Actions will automatically:

1. Build binaries for Linux (GCC and Clang), Windows, and macOS
2. Generate a changelog from git commit history
3. Create a GitHub Release
4. Upload build artifacts to the release

The release workflow can be monitored at:
https://github.com/DRSDavidSoft/pxlib/actions/workflows/release.yml

### 6. Verify Release

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
