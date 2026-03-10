#!/bin/bash
# Stop ClaudeClaw gracefully
STORE_DIR="${STORE_DIR:-$(dirname "$0")/../store}"
PID_FILE="$STORE_DIR/claudeclaw.pid"

if [ ! -f "$PID_FILE" ]; then
  echo "ClaudeClaw is not running (no PID file)."
  exit 0
fi

PID=$(cat "$PID_FILE")

if ! kill -0 "$PID" 2>/dev/null; then
  echo "ClaudeClaw is not running (stale PID $PID). Cleaning up."
  rm -f "$PID_FILE"
  exit 0
fi

echo "Stopping ClaudeClaw (PID $PID)..."
kill "$PID"

# Wait for it to actually die (up to 10s)
for i in $(seq 1 40); do
  if ! kill -0 "$PID" 2>/dev/null; then
    echo "Stopped."
    exit 0
  fi
  sleep 0.25
done

echo "Process didn't stop gracefully. Force killing..."
kill -9 "$PID" 2>/dev/null
rm -f "$PID_FILE"
echo "Killed."
