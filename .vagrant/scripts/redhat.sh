#!/usr/bin/env bash

COLS=$(tput cols)
title="For Redhat"

printf '%*s\n' "$COLS" '' | tr ' ' '='
printf '%*s\n' $(( (COLS + ${#title}) / 2 )) "$title"
printf '%*s\n' "$COLS" '' | tr ' ' '='

if [ -x "$(command -v subscription-manager)" ]; then
  subscription-manager register --force --org="19047241" --activationkey="redhat10"
fi

if [ -x "$(command -v setenforce)" ]; then
  # 1. Temporarily set SELinux to Permissive to allow the file write
  setenforce 0
  # 2. Modify eth1 to never be the default gateway
  nmcli connection modify eth1 ipv4.never-default yes
  # 3. Apply changes
  nmcli connection up eth1
  # 4. Re-enable SELinux Enforcing mode
  setenforce 1
fi
