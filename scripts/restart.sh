#!/bin/bash
# Restart ClaudeClaw: stop, wait for Telegram to release polling, start
DIR="$(dirname "$0")/.."

echo "=== Stopping ==="
bash "$DIR/scripts/stop.sh"

# Telegram holds the polling connection for a few seconds after the process dies.
# Wait for it to expire so bot.start() doesn't get a 409 Conflict.
echo "Waiting for Telegram to release polling session..."
sleep 3

echo "=== Starting ==="
cd "$DIR"
npm start
