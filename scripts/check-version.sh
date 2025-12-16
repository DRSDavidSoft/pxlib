#!/bin/bash
# Script to check version consistency across the repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Checking version consistency..."
echo ""

# Read the canonical version from VERSION file
if [ ! -f "${REPO_ROOT}/VERSION" ]; then
    echo -e "${RED}ERROR: VERSION file not found${NC}"
    exit 1
fi

CANONICAL_VERSION=$(cat "${REPO_ROOT}/VERSION" | tr -d '[:space:]')
echo "Canonical version from VERSION file: ${CANONICAL_VERSION}"

# Split version into parts
IFS='.' read -r MAJOR MINOR MICRO <<< "${CANONICAL_VERSION}"

# Track if all checks pass
ALL_CHECKS_PASSED=true

# Function to check version components in CMakeLists.txt
check_cmake_version() {
    local file="${REPO_ROOT}/CMakeLists.txt"
    
    if [ ! -f "${file}" ]; then
        echo -e "${YELLOW}WARNING: CMakeLists.txt not found${NC}"
        return
    fi
    
    local cmake_major=$(grep 'set(PXLIB_MAJOR_VERSION' "${file}" | sed -E 's/.*"([0-9]+)".*/\1/')
    local cmake_minor=$(grep 'set(PXLIB_MINOR_VERSION' "${file}" | sed -E 's/.*"([0-9]+)".*/\1/')
    local cmake_micro=$(grep 'set(PXLIB_MICRO_VERSION' "${file}" | sed -E 's/.*"([0-9]+)".*/\1/')
    local cmake_version="${cmake_major}.${cmake_minor}.${cmake_micro}"
    
    if [ "${cmake_version}" == "${CANONICAL_VERSION}" ]; then
        echo -e "${GREEN}✓${NC} CMakeLists.txt: ${cmake_version}"
    else
        echo -e "${RED}✗${NC} CMakeLists.txt: ${cmake_version} (expected: ${CANONICAL_VERSION})"
        echo "   MAJOR: ${cmake_major} (expected: ${MAJOR})"
        echo "   MINOR: ${cmake_minor} (expected: ${MINOR})"
        echo "   MICRO: ${cmake_micro} (expected: ${MICRO})"
        ALL_CHECKS_PASSED=false
    fi
}

# Function to check version components in configure.ac
check_configure_version() {
    local file="${REPO_ROOT}/configure.ac"
    
    if [ ! -f "${file}" ]; then
        echo -e "${YELLOW}WARNING: configure.ac not found${NC}"
        return
    fi
    
    # Check AC_INIT version
    local ac_init_version=$(grep 'AC_INIT' "${file}" | sed -E 's/AC_INIT\(\[pxlib\], \[([0-9.]+)\].*/\1/')
    
    if [ "${ac_init_version}" == "${CANONICAL_VERSION}" ]; then
        echo -e "${GREEN}✓${NC} configure.ac (AC_INIT): ${ac_init_version}"
    else
        echo -e "${RED}✗${NC} configure.ac (AC_INIT): ${ac_init_version} (expected: ${CANONICAL_VERSION})"
        ALL_CHECKS_PASSED=false
    fi
    
    # Check individual version variables
    local conf_major=$(grep '^PXLIB_MAJOR_VERSION=' "${file}" | sed -E 's/PXLIB_MAJOR_VERSION=([0-9]+).*/\1/')
    local conf_minor=$(grep '^PXLIB_MINOR_VERSION=' "${file}" | sed -E 's/PXLIB_MINOR_VERSION=([0-9]+).*/\1/')
    local conf_micro=$(grep '^PXLIB_MICRO_VERSION=' "${file}" | sed -E 's/PXLIB_MICRO_VERSION=([0-9]+).*/\1/')
    local conf_version="${conf_major}.${conf_minor}.${conf_micro}"
    
    if [ "${conf_version}" == "${CANONICAL_VERSION}" ]; then
        echo -e "${GREEN}✓${NC} configure.ac (version vars): ${conf_version}"
    else
        echo -e "${RED}✗${NC} configure.ac (version vars): ${conf_version} (expected: ${CANONICAL_VERSION})"
        echo "   MAJOR: ${conf_major} (expected: ${MAJOR})"
        echo "   MINOR: ${conf_minor} (expected: ${MINOR})"
        echo "   MICRO: ${conf_micro} (expected: ${MICRO})"
        ALL_CHECKS_PASSED=false
    fi
}

echo ""
echo "Checking version in project files:"
echo "-----------------------------------"

check_cmake_version
check_configure_version

echo ""

if [ "${ALL_CHECKS_PASSED}" = true ]; then
    echo -e "${GREEN}All version checks passed!${NC}"
    exit 0
else
    echo -e "${RED}Version inconsistencies detected!${NC}"
    echo ""
    echo "To fix version inconsistencies, run:"
    echo "  ./scripts/update-version.sh ${CANONICAL_VERSION}"
    exit 1
fi
