#!/usr/bin/env bash
# Runs the tests, or with "specimen", draws docs/specimen.png. This repository is a Godot add-on, not a
# Godot project: games take it in at addons/itrium_pixel_font. So the tests run in a throwaway
# project that holds the add-on the same way a game does.
#
#   GODOT=/path/to/godot tools/test.sh [specimen]
#
# GODOT defaults to `godot` on the path.

set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
godot="${GODOT:-godot}"
project="$(mktemp -d)"
trap 'rm -rf "$project"' EXIT

mkdir -p "$project/addons/itrium_pixel_font" "$project/tests" "$project/tools"
cp "$here"/*.gd "$project/addons/itrium_pixel_font/"
cp "$here"/tests/*.gd "$project/tests/"
cp "$here"/tools/*.gd "$project/tools/"
cat > "$project/project.godot" <<'PROJECT'
config_version=5

[application]

config/name="Itrium Pixel tests"
config/features=PackedStringArray("4.7", "GL Compatibility")

[rendering]

renderer/rendering_method="gl_compatibility"
PROJECT

# Importing builds the class name cache; it can report editor errors that don't matter here.
"$godot" --headless --path "$project" --import > /dev/null 2>&1 || true
if [ "${1:-}" = "specimen" ]; then
  "$godot" --headless --path "$project" --script tools/specimen.gd -- "$here/docs/specimen.png"
else
  "$godot" --headless --path "$project" --script tests/run_tests.gd
fi
