# Test Suite

Comprehensive test suite for the Ansible Vault encryption pre-commit hook.

## Running Tests

Run all tests:
```bash
./tests/run_tests.sh
```

## Test Coverage

The test suite covers the following scenarios:

1. **Encrypted vault file** - Verifies encrypted files pass validation
2. **Unencrypted vault file** - Verifies unencrypted files are rejected
3. **Filenames with spaces** - Tests robust handling of special filenames
4. **Case insensitive matching** - Verifies "VAULT", "vault", "Vault" all work
5. **Multiple files (all encrypted)** - Tests batch processing of valid files
6. **Multiple files (one unencrypted)** - Ensures one bad file fails the check
7. **No vault files** - Tests behavior when no files need checking
8. **Vault in subdirectory** - Verifies paths with directories work correctly
9. **Deleted files** - Tests graceful handling of non-existent files
10. **Mixed case vault names** - Tests "myVaultFile" variations
11. **Special characters** - Tests dashes, underscores, numbers in filenames
12. **Empty vault files** - Verifies empty files are rejected

## Test Output

Tests display color-coded results:
- ✓ Green checkmark for passing tests
- ✗ Red X for failing tests
- Final summary with pass/fail counts

## Requirements

- Bash 4.0+
- Git
- grep

The test suite creates temporary directories for each test and cleans up automatically.
