#!/bin/bash
# Send a Telegram message mid-task.
# Usage: notify.sh "message text"
# Reads TELEGRAM_BOT_TOKEN and ALLOWED_CHAT_ID from .env in the project root.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "notify.sh: .env not found at $ENV_FILE" >&2
  exit 1
fi

TOKEN=$(grep -E '^TELEGRAM_BOT_TOKEN=' "$ENV_FILE" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
CHAT_ID=$(grep -E '^ALLOWED_CHAT_ID=' "$ENV_FILE" | cut -d'=' -f2- | tr -d '"' | tr -d "'")

if [ -z "$TOKEN" ] || [ -z "$CHAT_ID" ]; then
  echo "notify.sh: TELEGRAM_BOT_TOKEN or ALLOWED_CHAT_ID not set in .env" >&2
  exit 1
fi

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 \
  -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
  -d chat_id="${CHAT_ID}" \
  -d text="${1}" \
  -d parse_mode="HTML")

if [ "$HTTP_CODE" != "200" ]; then
  echo "notify.sh: Telegram API returned HTTP $HTTP_CODE" >&2
  exit 1
fi
