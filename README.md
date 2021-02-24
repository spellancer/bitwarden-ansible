# bitwarden-ansible

Unofficial Ansible playbooks for deploying on-premise [Bitwarden](https://bitwarden.com/) installation from the source.
> Warning: You should use the preffered installation way: https://bitwarden.com/help/article/install-on-premise/. Use the manual installation way only if you understand what you are doing and why you need that.

Based the official instructions for the manual installation way:
https://bitwarden.com/help/article/install-on-premise-manual/

## Requirements

- `ansible-galaxy collection install community.general`
- local: `pip install hvac`
- remote: `pip install docker docker-compose`
- Optional: Hashicorp Vault client


## Usage

### Prepare playbooks

Fork this repo for yourself to edit them as you wish.
You need to change and fill something, before proceeding to testing:

0. Install requirements
1. Prepare and pass secrets variable (as dictionary) - better from external secrets storage like Hashicorp Vault. Checkout deploy.yml for example
2. Edit the environments/*:
    - fill the hosts files
    - edit the group_vars files: provide required values for variables
3. Edit the main configuration file template - global.override.conf.j2 in roles/bitwarden/templates
4. Replace / edit the mssql config file template - mssql.override.env.j2 in roles/bitwarden/templates
5. Replace /edit the bitwarden-nginx container config file - default.conf.j2 in roles/bitwarden/templates
> Note: Provided default.conf 2 is not the original one provided in the source. It's edited to be used with front-facing load balancer, which terminates SSL. Please use the official one.
6. Edit the main role variables file: roles/bitwarden/vars/main.yml
7. Generate certificates as provided in the instruction: https://bitwarden.com/help/article/install-on-premise-manual/, and place them in files/{prod/stg}/identity.pfx and files/ca.crt files. Save the private keys somewhere safe.
8. Checkout the latest version number and edit the version variable in the main playbook - deploy.yml.


### Initial deploy

> Provide required environment via -i option

Steps:
1. Prepare and pass secrets variable (as dictionary) - better from external secrets storage like Hashicorp Vault
2. Run high-level playbook:
```
ansible-playbook -i environments/stage deploy.yml --extra-vars "vault_token=<token>"
```
> If you have problem Ansible client for macOS: `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES; ansible-playbook -i environments/stage deploy.yml --extra-vars "vault_token=<token>"`


### Redeploy without upgrade

Run the 1,2 steps from "Initial deploy" section.

### Upgrade installation

Official instructions: https://bitwarden.com/help/updating-on-premise

1. Create the database backup
2. Check the database backup
3. Update Bitwarden release version in deploy.yml version var
4. Run the same steps as for "Initial deploy". Note: you should checkout / clone the upgrade version repository for step 3.

## Known bugs & Problems

### macOS Ansible client problem
- macOS: fork security bug (https://github.com/ansible/ansible/issues/32499):
> objc[12784]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.

Fix: `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES`

### Problems with database after installation upgrade

You should not comment out in docker-compose or stop bitwarden-mssql container if you are using external database!
