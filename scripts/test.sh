#!/usr/bin/env bash
# Run all Daml Script tests across all modules.
set -euo pipefail
cd "$(dirname "$0")/.."
echo "Running Daml Script tests..."
daml test
echo "All tests passed."
