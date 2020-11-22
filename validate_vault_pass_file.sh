#!/usr/bin/env bash

vault_pass=".vault_pass"
if [[ ! -f $vault_pass ]]; then
  echo "ERROR: no $vault_pass file found"
  exit 1
fi