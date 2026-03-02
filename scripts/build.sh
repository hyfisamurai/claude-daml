#!/usr/bin/env bash
# Build all Daml modules and produce the .dar archive.
set -euo pipefail
cd "$(dirname "$0")/.."
echo "Building claude-daml..."
daml build
echo "Build complete: $(ls .daml/dist/claude-daml-*.dar)"
