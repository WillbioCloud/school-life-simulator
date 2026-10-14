#!/usr/bin/env bash
# Runs the integration tests with a *template* Godot binary (no editor), e.g. one compiled with
# `scons target=template_debug`. Templates refuse `--path` and need the class-name cache that the
# editor would normally write, so the project is mirrored into a temporary folder next to the binary
# (see docs/VALIDATION.md). With a normal Godot installation prefer tests/run.sh.
set -uo pipefail
cd "$(dirname "$0")/.."
GODOT_TEMPLATE="${GODOT_TEMPLATE:?Set GODOT_TEMPLATE to a template_debug binary}"
RUN="$(mktemp -d)"
TEST_HOME="$(mktemp -d)"
trap 'rm -rf "$RUN" "$TEST_HOME"' EXIT
tar --exclude=.git --exclude=.godot -cf - . | (cd "$RUN" && tar -xf -)
cp "$GODOT_TEMPLATE" "$RUN/godot"
python3 tests/tools/gen_class_cache.py "$RUN" >/dev/null
printf '[application]\nrun/main_scene="res://tests/test_runner.tscn"\n' > "$RUN/override.cfg"
(cd "$RUN" && SCHOOL_LIFE_TEST=1 XDG_DATA_HOME="$TEST_HOME" timeout "${TEST_TIMEOUT:-600}" ./godot --headless --fixed-fps 60 --quit-after 1800) 2>&1 | tee "$TEST_HOME/test.log"
if grep -Eq 'SCRIPT ERROR|ERROR:|FAIL:' "$TEST_HOME/test.log"; then
  exit 1
fi
grep -Eq 'RESULT: [0-9]+ checks, 0 failures' "$TEST_HOME/test.log"
