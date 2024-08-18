#!/bin/bash
BOOTNODE_KEY="bootnode.key"
BOOTNODE_ADDRESS="bootnode.address"

update_env_value() {
  local env_file=$1
  local key=$2
  local new_value=$3

  if [ -z "$env_file" ] || [ -z "$key" ] || [ -z "$new_value" ]; then
    echo "Usage: update_env_value <env_file> <key> <new_value>"
    return 1
  fi

  if [ ! -f "$env_file" ]; then
    echo "File $env_file does not exist."
    return 1
  fi

  if sed --version >/dev/null 2>&1; then
    sed -i "s/^${key}=.*/${key}=${new_value}/" "$env_file"
  else
    # macOS sed
    sed -i '' "s/^${key}=.*/${key}=${new_value}/" "$env_file"
  fi

  echo "Updated ${key} to ${new_value} in ${env_file}"
}

echo "checking $BOOTNODE_KEY"
if [ -e ./$BOOTNODE_KEY ]; then
  echo "$BOOTNODE_KEY exist"
else
  echo "$BOOTNODE_KEY is creating"
  bootnode -genkey $BOOTNODE_KEY
  echo "$BOOTNODE_KEY was created"
fi
bootnode -nodekeyhex $(cat ./$BOOTNODE_KEY) -writeaddress >$BOOTNODE_ADDRESS

if [ -e .env ]; then
  echo ".env exist"
else
  echo ".env is creating"
  cp .env.example .env
  echo ".env was created"
fi

echo "updating bootnode detail to .env"
update_env_value "./.env" "BOOTNODE_KEY" "$(cat ./$BOOTNODE_KEY)"
update_env_value "./.env" "BOOTNODE_ADDRESS" "$(cat ./$BOOTNODE_ADDRESS)"
