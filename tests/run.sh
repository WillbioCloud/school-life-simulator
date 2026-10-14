#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
GODOT="${GODOT:-godot}"
# This intentionally isolates saves so integration tests never touch player progress.
TEST_HOME="$(mktemp -d)"
trap 'rm -rf "$TEST_HOME"' EXIT
export XDG_DATA_HOME="$TEST_HOME"
export SCHOOL_LIFE_TEST=1
if [[ "${SKIP_IMPORT:-0}" != "1" ]]; then
  "$GODOT" --headless --editor --import --path . --quit
fi
"$GODOT" --headless --fixed-fps 60 --quit-after 1800 --path . res://tests/test_runner.tscn 2>&1 | tee "$TEST_HOME/test.log"
if grep -Eq 'SCRIPT ERROR|ERROR:|FAIL:' "$TEST_HOME/test.log"; then
  exit 1
fi
grep -Eq 'RESULT: [0-9]+ checks, 0 failures' "$TEST_HOME/test.log"
