#!/usr/bin/env bash
#
# Ansible Vault encryption check pre-commit hook
# Checks for files with "vault" in the filename
# and prevents the commit if not encrypted.

set -e

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Find all files with "vault" in the filename
files=$(git ls-files | grep "vault")

# Check if any vault files were found
if [ -z "$files" ]; then
  echo -e "${GREEN}Vault not found, committing changes.${NC}"
  exit 0
fi

# Loop through each file and check if encrypted with Ansible Vault
for file in $files; do
  if ! git show ":$file" | grep -q "\$ANSIBLE_VAULT;"; then
    echo -e "${RED}Vault '${file}' is not encrypted! Run 'ansible-vault encrypt ${file} && git add ${file}' and try again.${NC}"
    exit 1
  else
    echo -e "${GREEN}Vault '${file}' is encrypted.${NC}"
  fi
done
