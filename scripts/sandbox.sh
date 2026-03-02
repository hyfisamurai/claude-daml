#!/usr/bin/env bash
# Start the local Canton sandbox and navigator UI.
# Run scripts/build.sh first to produce the .dar.
set -euo pipefail
cd "$(dirname "$0")/.."

DAR=$(ls .daml/dist/claude-daml-*.dar 2>/dev/null | head -1)
if [ -z "$DAR" ]; then
  echo "ERROR: No .dar found. Run scripts/build.sh first."
  exit 1
fi

echo "Starting Canton sandbox with $DAR ..."
daml sandbox --dar "$DAR" &
SANDBOX_PID=$!

echo "Starting Daml Navigator at http://localhost:7500 ..."
daml navigator server localhost 6865

wait "$SANDBOX_PID"
