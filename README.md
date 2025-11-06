# Pre-commit Hook to Check Ansible Vault Encryption

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A robust pre-commit hook that prevents accidentally committing unencrypted Ansible Vault files to your repository. This script acts as a safety mechanism when working with `ansible-vault`, ensuring sensitive data remains encrypted.

## Features

- **Automatic Detection**: Checks any file with `vault` in its filename (case-insensitive)
- **Robust File Handling**: Properly handles filenames with spaces and special characters
- **Pre-commit Integration**: Seamlessly works with the pre-commit framework
- **Shellcheck Validated**: Passes shellcheck with no warnings
- **Clear Feedback**: Color-coded output for easy identification of issues

By default, the script checks any file with `vault` in its filename. It's recommended to include `vault` in the names of all files containing secrets for this check to work effectively.

## Requirements

- **Bash**: Version 4.0 or higher (uses arrays and modern bash features)
- **Git**: Any recent version
- **grep**: Standard GNU or BSD grep
- **pre-commit** (optional): For pre-commit framework integration

## Installation

### Using pre-commit Framework (Recommended)

1. Install pre-commit via pip:
    ```bash
    pip install pre-commit
    ```

2. Add to your `.pre-commit-config.yaml` in your repository root:
    ```yaml
    repos:
      - repo: https://github.com/brko7/pre-commit-hook-check-ansible-vault-encryption
        rev: v1.0.0  # Use the latest release tag
        hooks:
          - id: check-ansible-vault-encryption
    ```

3. Install the hook:
    ```bash
    pre-commit install
    ```

4. (Optional) Run against all files to test:
    ```bash
    pre-commit run --all-files
    ```

### Manual Installation

1. Clone this repository or download the script:
    ```bash
    curl -o .git/hooks/pre-commit https://raw.githubusercontent.com/brko7/pre-commit-hook-check-ansible-vault-encryption/main/check_ansible_vault_encryption.sh
    ```

2. Make the script executable:
    ```bash
    chmod +x .git/hooks/pre-commit
    ```

## Usage

Once installed, the hook runs automatically before each commit:

```bash
git add vault_passwords.yml
git commit -m "Add passwords"
```

### Example Output

**✅ Encrypted vault (passes):**
```
Vault 'ansible/vault_passwords.yml' is encrypted.
[main abc1234] Add passwords
 1 file changed, 10 insertions(+)
```

**❌ Unencrypted vault (fails):**
```
Vault 'ansible/vault_passwords.yml' is not encrypted! Run 'ansible-vault encrypt ansible/vault_passwords.yml && git add ansible/vault_passwords.yml' and try again.
```

### What Gets Checked?

The hook checks any file with `vault` in its name (case-insensitive):
- ✅ `vault_passwords.yml`
- ✅ `group_vars/production/vault.yml`
- ✅ `secrets_VAULT_file.txt`
- ✅ `VAULT_credentials.json`
- ❌ `passwords.yml` (no "vault" in name)

### Ansible Vault File Format

A properly encrypted Ansible Vault file starts with:
```
$ANSIBLE_VAULT;1.1;AES256
66386439653765343264623132353534623566303535646461393437346136306561623762636566
...
```

To encrypt a file:
```bash
ansible-vault encrypt vault_passwords.yml
```

## Troubleshooting

### Hook Not Running

If the hook doesn't run:
```bash
# Verify installation
pre-commit run --all-files

# Reinstall if needed
pre-commit clean
pre-commit install
```

### Bash Version Issues

Check your bash version:
```bash
bash --version
```

This script requires Bash 4.0+. On macOS, you may need to install a newer version:
```bash
brew install bash
```

### Bypassing the Hook

**⚠️ Security Warning**: You can bypass pre-commit hooks with `--no-verify`:
```bash
git commit --no-verify -m "Dangerous: bypasses encryption check"
```

**Never bypass this hook** unless you're certain no sensitive data is being committed.

### False Positives

If you have a file with "vault" in the name that shouldn't be checked:
1. Rename the file to not include "vault"
2. Or exclude it in `.pre-commit-config.yaml`:
   ```yaml
   hooks:
     - id: check-ansible-vault-encryption
       exclude: 'path/to/false_positive.yml'
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.
