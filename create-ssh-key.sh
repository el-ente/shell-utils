#!/bin/bash

read -r -p "Create a new SSH key? [y/N] " create_key
if [[ ! "$create_key" =~ ^[Yy]$ ]]; then
    exit 0
fi

read -r -p "Email for the key: " ssh_email
read -r -p "Key file name (default: id_ed25519): " ssh_name
ssh_name="${ssh_name:-id_ed25519}"
ssh_path="$HOME/.ssh/$ssh_name"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ -f "$ssh_path" ]; then
    echo "Key already exists at $ssh_path, skipping generation"
else
    ssh-keygen -t ed25519 -C "$ssh_email" -f "$ssh_path"
fi

SSH_CONFIG="$HOME/.ssh/config"
touch "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"
if ! grep -q "IdentityFile $ssh_path" "$SSH_CONFIG"; then
    {
        echo ""
        echo "Host *"
        echo "  AddKeysToAgent yes"
        echo "  UseKeychain yes"
        echo "  IdentityFile $ssh_path"
    } >> "$SSH_CONFIG"
fi

ssh-add --apple-use-keychain "$ssh_path"

echo ""
echo "Public key (add it to GitHub/Bitbucket):"
cat "$ssh_path.pub"
