# Pre-commit Hook to Check Ansible Vault Encryption

This repository contains a bash script that serves as a pre-commit hook. It checks for Ansible Vault encryption in your git-tracked projects. If you're using Ansible and `ansible-vault`, this script acts as a safety mechanism to prevent committing unencrypted vaults.

By default, the script checks any file with `vault` in its filename that's added to git. It's crucial to ensure all your secret files include `vault` in their names for this check to apply effectively.

## Installation

To use this pre-commit hook with [`pre-commit`](https://pre-commit.com), these are the steps:

1. Install pre-commit via pip
    ```bash
    pip install pre-commit
    ```

2. Go to your repo **root dir** and create `.pre-commit-config.yaml` file there
    ``` yaml
    - repo: https://github.com/brko7/pre-commit-hook-check-ansible-vault-encryption
      rev: v0.1 # or some other tag
      hooks:
        - id: check-ansible-vault-encryption
    ```

3. Install the hook in the repository
    ```bash
    pre-commit install
    ```

4. Manually run pre-commit to test the config
    ```bash
    pre-commit run --all-files
    ```

To use this pre-commit hook locally in your project, follow these steps:

1. Clone this repository or download the script
2. Copy the script `check_ansible_vault_encryption.sh` to your project's `.git/hooks` directory and rename it to `pre-commit`
3. Make the `pre-commit` file executable:

    ```bash
    chmod +x .git/hooks/pre-commit
    ```

## Usage

Once the pre-commit hook is installed, it will automatically run before each commit. If any unencrypted Ansible Vault files are found, the commit will be rejected and you will be warned.

## Contributing

Contributions are welcome! If you have any suggestions or improvements, please open an issue or submit a pull request. Thank you!
