#!/bin/bash
# Script to update version across all project files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Check if version is provided
if [ $# -ne 1 ]; then
    echo -e "${RED}Usage: $0 <version>${NC}"
    echo "Example: $0 0.6.9"
    exit 1
fi

NEW_VERSION=$1

# Validate version format (X.Y.Z)
if ! [[ $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}ERROR: Invalid version format. Expected: X.Y.Z${NC}"
    exit 1
fi

# Split version into parts
IFS='.' read -r MAJOR MINOR MICRO <<< "${NEW_VERSION}"

echo "Updating version to: ${NEW_VERSION}"
echo "  MAJOR: ${MAJOR}"
echo "  MINOR: ${MINOR}"
echo "  MICRO: ${MICRO}"
echo ""

# Update VERSION file
echo "${NEW_VERSION}" > "${REPO_ROOT}/VERSION"
echo -e "${GREEN}✓${NC} Updated VERSION file"

# Update CMakeLists.txt
if [ -f "${REPO_ROOT}/CMakeLists.txt" ]; then
    sed -i "s/set(PXLIB_MAJOR_VERSION \"[0-9]*\")/set(PXLIB_MAJOR_VERSION \"${MAJOR}\")/" "${REPO_ROOT}/CMakeLists.txt"
    sed -i "s/set(PXLIB_MINOR_VERSION \"[0-9]*\")/set(PXLIB_MINOR_VERSION \"${MINOR}\")/" "${REPO_ROOT}/CMakeLists.txt"
    sed -i "s/set(PXLIB_MICRO_VERSION \"[0-9]*\")/set(PXLIB_MICRO_VERSION \"${MICRO}\")/" "${REPO_ROOT}/CMakeLists.txt"
    echo -e "${GREEN}✓${NC} Updated CMakeLists.txt"
else
    echo -e "${YELLOW}WARNING: CMakeLists.txt not found${NC}"
fi

# Update configure.ac
if [ -f "${REPO_ROOT}/configure.ac" ]; then
    # Update AC_INIT version
    sed -i "s/AC_INIT(\[pxlib\], \[[0-9.]*\]/AC_INIT([pxlib], [${NEW_VERSION}]/" "${REPO_ROOT}/configure.ac"
    
    # Update individual version variables
    sed -i "s/^PXLIB_MAJOR_VERSION=[0-9]*/PXLIB_MAJOR_VERSION=${MAJOR}/" "${REPO_ROOT}/configure.ac"
    sed -i "s/^PXLIB_MINOR_VERSION=[0-9]*/PXLIB_MINOR_VERSION=${MINOR}/" "${REPO_ROOT}/configure.ac"
    sed -i "s/^PXLIB_MICRO_VERSION=[0-9]*/PXLIB_MICRO_VERSION=${MICRO}/" "${REPO_ROOT}/configure.ac"
    
    echo -e "${GREEN}✓${NC} Updated configure.ac"
else
    echo -e "${YELLOW}WARNING: configure.ac not found${NC}"
fi

echo ""
echo -e "${GREEN}Version updated successfully to ${NEW_VERSION}${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the changes: git diff"
echo "  2. Verify version consistency: ./scripts/check-version.sh"
echo "  3. Update ChangeLog with release notes"
echo "  4. Commit changes: git add VERSION CMakeLists.txt configure.ac ChangeLog"
echo "  5. Create release: git commit -m 'Release version ${NEW_VERSION}'"
