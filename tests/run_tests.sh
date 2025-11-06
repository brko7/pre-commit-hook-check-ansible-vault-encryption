#!/usr/bin/env bash
#
# Test suite for check_ansible_vault_encryption.sh
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOK_SCRIPT="$PROJECT_ROOT/check_ansible_vault_encryption.sh"

# Test temp directory
TEST_DIR=""

# Cleanup function
# shellcheck disable=SC2329  # Function is invoked by trap
cleanup() {
  if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
    rm -rf "$TEST_DIR"
  fi
}

trap cleanup EXIT

# Setup test environment
setup_test() {
  TEST_DIR=$(mktemp -d)
  cd "$TEST_DIR"
  git init -q
  git config user.email "test@example.com"
  git config user.name "Test User"
}

# Test assertion helpers
assert_success() {
  local test_name=$1
  shift
  TESTS_RUN=$((TESTS_RUN + 1))

  if "$@" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} $test_name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗${NC} $test_name"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

assert_failure() {
  local test_name=$1
  shift
  TESTS_RUN=$((TESTS_RUN + 1))

  if ! "$@" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} $test_name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗${NC} $test_name"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Create an encrypted vault file
create_encrypted_vault() {
  local filename=$1
  cat > "$filename" << 'EOF'
$ANSIBLE_VAULT;1.1;AES256
66386439653765343264623132353534623566303535646461393437346136306561623762636566
3835626533653363356564336162656335623435336262640a653034313335623062666233333437
6663663565346437383535323734623461656230303763390a663238346636623639343034663463
3531
EOF
}

# Create an unencrypted vault file
create_unencrypted_vault() {
  local filename=$1
  cat > "$filename" << 'EOF'
---
password: supersecret
api_key: 12345
EOF
}

# Test 1: Encrypted vault file should pass
test_encrypted_vault_passes() {
  setup_test
  create_encrypted_vault "vault_passwords.yml"
  assert_success "Encrypted vault file passes" bash "$HOOK_SCRIPT" vault_passwords.yml
}

# Test 2: Unencrypted vault file should fail
test_unencrypted_vault_fails() {
  setup_test
  create_unencrypted_vault "vault_passwords.yml"
  assert_failure "Unencrypted vault file fails" bash "$HOOK_SCRIPT" vault_passwords.yml
}

# Test 3: File with spaces in name
test_filename_with_spaces() {
  setup_test
  create_encrypted_vault "vault with spaces.yml"
  assert_success "Vault with spaces in filename passes" bash "$HOOK_SCRIPT" "vault with spaces.yml"
}

# Test 4: Case insensitive matching
test_case_insensitive() {
  setup_test
  create_encrypted_vault "VAULT_PASSWORDS.YML"
  assert_success "Uppercase VAULT in filename passes" bash "$HOOK_SCRIPT" VAULT_PASSWORDS.YML
}

# Test 5: Multiple files - all encrypted
test_multiple_files_encrypted() {
  setup_test
  create_encrypted_vault "vault1.yml"
  create_encrypted_vault "vault2.yml"
  assert_success "Multiple encrypted vaults pass" bash "$HOOK_SCRIPT" vault1.yml vault2.yml
}

# Test 6: Multiple files - one unencrypted
test_multiple_files_one_unencrypted() {
  setup_test
  create_encrypted_vault "vault1.yml"
  create_unencrypted_vault "vault2.yml"
  assert_failure "Multiple vaults with one unencrypted fails" bash "$HOOK_SCRIPT" vault1.yml vault2.yml
}

# Test 7: No files passed, no vault files exist
test_no_vault_files() {
  setup_test
  echo "not a vault" > "regular_file.txt"
  git add regular_file.txt
  assert_success "No vault files to check passes" bash "$HOOK_SCRIPT"
}

# Test 8: Subdirectories
test_vault_in_subdirectory() {
  setup_test
  mkdir -p group_vars/production
  create_encrypted_vault "group_vars/production/vault.yml"
  assert_success "Vault in subdirectory passes" bash "$HOOK_SCRIPT" group_vars/production/vault.yml
}

# Test 9: Non-existent file (deleted scenario)
test_deleted_file() {
  setup_test
  # Hook should handle non-existent files gracefully
  assert_success "Non-existent file handled gracefully" bash "$HOOK_SCRIPT" nonexistent_vault.yml
}

# Test 10: Vault in filename but different case
test_vault_mixed_case() {
  setup_test
  create_encrypted_vault "myVaultFile.yml"
  assert_success "Mixed case 'Vault' in filename passes" bash "$HOOK_SCRIPT" myVaultFile.yml
}

# Test 11: Special characters in filename
test_special_characters() {
  setup_test
  create_encrypted_vault "vault-passwords_2024.yml"
  assert_success "Vault with special characters passes" bash "$HOOK_SCRIPT" vault-passwords_2024.yml
}

# Test 12: Empty file with vault in name
test_empty_vault_file() {
  setup_test
  touch "vault_empty.yml"
  assert_failure "Empty file with vault in name fails" bash "$HOOK_SCRIPT" vault_empty.yml
}

# Run all tests
echo -e "${YELLOW}Running tests for check_ansible_vault_encryption.sh${NC}\n"

test_encrypted_vault_passes
test_unencrypted_vault_fails
test_filename_with_spaces
test_case_insensitive
test_multiple_files_encrypted
test_multiple_files_one_unencrypted
test_no_vault_files
test_vault_in_subdirectory
test_deleted_file
test_vault_mixed_case
test_special_characters
test_empty_vault_file

# Summary
echo ""
echo "======================================"
echo -e "Tests run: $TESTS_RUN"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
  echo -e "${RED}Failed: $TESTS_FAILED${NC}"
  echo "======================================"
  exit 1
else
  echo -e "${GREEN}All tests passed!${NC}"
  echo "======================================"
  exit 0
fi
