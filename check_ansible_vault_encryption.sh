#!/usr/bin/env bash
#
# Ansible Vault encryption check pre-commit hook
# Checks for files with "vault" in the filename
# and prevents the commit if not encrypted.

set -euo pipefail

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if git is available
if ! command -v git &> /dev/null; then
  echo -e "${RED}Error: git command not found${NC}" >&2
  exit 1
fi

# Use files passed by pre-commit, or fall back to searching
if [ $# -eq 0 ]; then
  # No files passed, search for vault files (case-insensitive)
  files=()
  while IFS= read -r -d '' file; do
    files+=("$file")
  done < <(git ls-files -z | grep -ziZ "vault")

  if [ ${#files[@]} -eq 0 ]; then
    echo -e "${GREEN}No vault files found, committing changes.${NC}"
    exit 0
  fi
else
  # Files passed by pre-commit
  files=("$@")
fi

# Track if any issues found
issues_found=0

# Loop through each file and check if encrypted with Ansible Vault
for file in "${files[@]}"; do
  # Skip if file doesn't exist (might be deleted)
  if [ ! -f "$file" ]; then
    continue
  fi

  # Check first line for Ansible Vault header
  # shellcheck disable=SC2016  # Single quotes intentional - we want literal \$ for grep
  if ! head -n 1 "$file" | grep -q '^\$ANSIBLE_VAULT;'; then
    echo -e "${RED}Vault '${file}' is not encrypted! Run 'ansible-vault encrypt ${file} && git add ${file}' and try again.${NC}" >&2
    issues_found=1
  else
    echo -e "${GREEN}Vault '${file}' is encrypted.${NC}"
  fi
done

if [ $issues_found -eq 1 ]; then
  exit 1
fi

exit 0
