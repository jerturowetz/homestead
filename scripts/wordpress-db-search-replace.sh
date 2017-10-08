#!/usr/bin/env bash
SITE_DIR="${1}"
FIND="${2}"
REPLACE_WITH="${3}"

# Search replace old url to new url on db
cd "${SITE_DIR}"
echo "Running search & replace tasks"
wp search-replace "${FIND}" "${REPLACE_WITH}" --format=count
