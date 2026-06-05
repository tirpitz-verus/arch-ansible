# AGENTS.md

## Project overview

Personal Ansible playbooks for setting up Arch Linux installations. Each machine has its own playbook, inventory, and (optionally) an Ansible Vault file for secrets.

## Machines

- choinka
- xps13

## Repo structure

```
<hostname>.yml            — playbook for the machine (roles + ad-hoc tasks)
<hostname>_inv.yml        — Ansible inventory (localhost connection)
<hostname>_inv_v.yml      — Ansible Vault encrypted vars (secrets)
roles/<role_name>/        — reusable Ansible roles
  tasks/main.yml          — role tasks
  handlers/main.yml       — role handlers (if any)
clean_up.yaml             — shared cleanup/removal tasks (included by playbooks)
initial_setup_*.sh        — post-install bootstrap scripts (run before Ansible)
.vault_pass               — vault password file (gitignored, never commit)
```

## How to run

```bash
./run_playbook.sh                  # runs playbook for current hostname, requires system to be up-to-date
./run_playbook.sh <hostname>       # runs playbook for a specific hostname
./run_playbook_without_update_safeguard.sh  # same but skips the pacman -Syup check
```

The scripts prompt for sudo password and handle vault decryption automatically when a `*_inv_v.yml` file exists.

## Conventions

- **AUR packages**: Installed via the `aur_builder` user with the `aur` module. The `aur_builder` user must be set up during initial installation scripts before Ansible runs.
- **Cleanup tasks**: Removal/deprecation cleanup goes in `clean_up.yaml`, not in role files. Playbooks include it via `include_tasks: clean_up.yaml`. Each cleanup block is dated.
- **Config files**: Copied or templated into `~/.config/` per user. Use `~{{ item }}` loops over `users_to_setup` when applying per-user configs.
- **Vault secrets**: Encrypted files follow the `<hostname>_inv_v.yml` naming pattern. The vault password file `.vault_pass` is gitignored — never commit it or any secrets.
- **Variables**: `users_to_setup` is defined per playbook (list of usernames). Other vars like `developers`, `wegiel_ip` come from vault files.
- **Playbook format**: Roles are listed under `roles:`, ad-hoc tasks (CPU microcode, backup scripts, AUR packages) go under `tasks:` at the bottom. Roles can be commented out to selectively run parts.
- **Idempotency**: Roles should be idempotent — running them multiple times should not change state if already configured. Use `state: present` for packages, `creates` guards for commands, and check-before-create patterns for files.

## Constraints

- System must be up-to-date (`pacman -Syu` + `yay -Syu`) before running `run_playbook.sh` — the safeguard script checks this.
- Never commit `.vault_pass` or any decrypted vault content.
- Never modify vault files without re-encrypting: use `./edit_vault_var_file.sh` or `ansible-vault edit`.
- This repo is for personal use — roles are tailored to specific hardware and preferences, not generic.