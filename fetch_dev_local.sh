#!/usr/bin/env bash
set -euo pipefail

# Usage: ./fetch_dev_local.sh <OP_SERVICE_ACCOUNT_TOKEN>
# Prompts for: Vault name, Item/File name (default dev_local.py), destination path.
# Requires: 1Password CLI (v2+): https://developer.1password.com/docs/cli/get-started/

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <OP_SERVICE_ACCOUNT_TOKEN>"
  exit 1
fi

OP_TOKEN="$1"
OP_ITEM_DEFAULT="dev_local.py"

read -r -p "1Password vault name: " OP_VAULT
if [[ -z "${OP_VAULT}" ]]; then
  echo "Vault name is required."
  exit 1
fi

read -r -p "Item or file name in 1Password [${OP_ITEM_DEFAULT}]: " OP_ITEM
OP_ITEM="${OP_ITEM:-$OP_ITEM_DEFAULT}"

read -r -p "Destination path for dev_local.py (full path, including filename) [/tmp/dev_local.py]: " DEST_PATH
DEST_PATH="${DEST_PATH:-/tmp/dev_local.py}"

# Check op CLI
if ! command -v op >/dev/null 2>&1; then
  echo "Error: 1Password CLI 'op' not found. Install: https://developer.1password.com/docs/cli/get-started/"
  exit 1
fi

# Login non-interactively using the service account token (no device pairing)
export OP_SERVICE_ACCOUNT_TOKEN="$OP_TOKEN"

echo "Verifying access to vault '${OP_VAULT}'..."
if ! op vault get "$OP_VAULT" >/dev/null 2>&1; then
  echo "Error: Unable to access vault '${OP_VAULT}'. Check name and token permissions."
  exit 1
fi

# Try to fetch as a file first; if not, try as an item document
TMPFILE="$(mktemp)"
CLEANUP() { rm -f "$TMPFILE"; }
trap CLEANUP EXIT

echo "Attempting to download '${OP_ITEM}' from vault '${OP_VAULT}'..."
set +e
op document get "$OP_ITEM" --vault "$OP_VAULT" --output "$TMPFILE" 2>/dev/null
DOC_STATUS=$?
set -e

if [[ $DOC_STATUS -ne 0 ]]; then
  echo "Falling back to 'op item' (treating as a file field on an item)..."
  # For items that contain a file field named dev_local.py
  ITEM_ID="$(op item get "$OP_ITEM" --vault "$OP_VAULT" --format json | jq -r '.id' 2>/dev/null || true)"
  if [[ -z "$ITEM_ID" || "$ITEM_ID" == "null" ]]; then
    echo "Error: Could not find item or document named '${OP_ITEM}' in vault '${OP_VAULT}'."
    exit 1
  fi

  FILE_ID="$(op item get "$ITEM_ID" --vault "$OP_VAULT" --format json | jq -r '.files[]?.id' 2>/dev/null | head -n1 || true)"
  if [[ -z "$FILE_ID" || "$FILE_ID" == "null" ]]; then
    echo "Error: Item '${OP_ITEM}' has no attached files."
    exit 1
  fi

  op item file get "$FILE_ID" --item "$ITEM_ID" --vault "$OP_VAULT" --output "$TMPFILE"
fi

mkdir -p "$(dirname "$DEST_PATH")"
cp "$TMPFILE" "$DEST_PATH"
chmod 600 "$DEST_PATH"

echo "Saved dev_local.py to: $DEST_PATH"
