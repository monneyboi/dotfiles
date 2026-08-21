#!/bin/bash
set -euo pipefail

export RCLONE_CONFIG_ROUTER_TYPE=smb
export RCLONE_CONFIG_ROUTER_HOST=192.168.178.1
export RCLONE_CONFIG_ROUTER_USER=johan
# Plaintext password stays in the keyring; obscure it for rclone (needs the
# stdin form in case the password starts with '-').
export RCLONE_CONFIG_ROUTER_PASS="$(secret-tool lookup service router-smb | rclone obscure -)"

exec /usr/bin/rclone "$@"
