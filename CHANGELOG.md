# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-11-06

### Added
- MIT License
- Comprehensive test suite with 12 test cases
- GitHub Actions CI/CD workflow
  - ShellCheck validation
  - Testing on Ubuntu
  - Pre-commit hook testing
  - Markdown linting
- CHANGELOG.md for version tracking
- .gitignore file for common artifacts
- Case-insensitive filename matching for "vault"
- Support for filenames with spaces and special characters
- Validation that git command exists
- README badges and enhanced documentation
  - Requirements section
  - Comprehensive installation instructions
  - Usage examples with sample output
  - Troubleshooting guide
  - Security warnings about bypassing hooks

### Changed
- **BREAKING**: Improved error handling with `set -euo pipefail`
- Script now accepts filenames as arguments from pre-commit
- Proper array handling to fix word-splitting vulnerabilities
- Error messages now output to stderr
- More efficient vault header checking (only checks first line)
- Better exit code handling with explicit success/failure tracking

### Fixed
- Critical bug: Word splitting vulnerability with filenames containing spaces
- Critical bug: Improper handling of files array causing incorrect behavior
- Security: Files with spaces in names now handled correctly
- Performance: Only check first line of file instead of entire content
- Reliability: Handle deleted files gracefully
- Reliability: Fixed grep pattern escaping for Ansible Vault header

### Security
- Fixed multiple vulnerabilities related to improper quoting and word splitting
- Added validation for git command availability
- Improved error handling to prevent silent failures

## [0.1.0] - 2024-07-14

### Added
- Initial release
- Basic Ansible Vault encryption checking
- Pre-commit hook configuration
- Basic README documentation

[Unreleased]: https://github.com/brko7/pre-commit-hook-check-ansible-vault-encryption/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/brko7/pre-commit-hook-check-ansible-vault-encryption/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/brko7/pre-commit-hook-check-ansible-vault-encryption/releases/tag/v0.1.0
