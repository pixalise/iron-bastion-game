#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="${GRAPHITE_BUILD_DIR:-${repo_root}/graphite/cmake-build-debug}"
generator="${GRAPHITE_CMAKE_GENERATOR:-Ninja}"
extension_file="${repo_root}/addons/graphite/graphite.gdextension"
debug_library="${repo_root}/addons/graphite/bin/libgraphite.linux.template_debug.x86_64.so"
godot_home="${GRAPHITE_GODOT_HOME:-/tmp/iron-bastion-godot-home}"

cd "${repo_root}"

if command -v pgrep >/dev/null && pgrep -f "godot.*${repo_root}" >/dev/null; then
	echo "Godot appears to be running for this project."
	echo "The rebuild can finish, but restart the editor to pick up renamed native methods."
fi

cmake -S graphite -B "${build_dir}" -G "${generator}" -DCMAKE_BUILD_TYPE=Debug
cmake --build "${build_dir}" --target graphite

if [[ ! -f "${extension_file}" ]]; then
	echo "Missing ${extension_file}; Godot cannot load the Graphite addon." >&2
	exit 1
fi

if [[ ! -f "${debug_library}" ]]; then
	echo "Missing ${debug_library}; the Graphite debug library was not produced." >&2
	exit 1
fi

mkdir -p "${godot_home}/config" "${godot_home}/data" "${godot_home}/cache"

HOME="${godot_home}" \
XDG_CONFIG_HOME="${godot_home}/config" \
XDG_DATA_HOME="${godot_home}/data" \
XDG_CACHE_HOME="${godot_home}/cache" \
	godot --headless --path "${repo_root}" --script graphite/smoke_test.gd

echo "Graphite rebuilt and smoke-tested."
echo "If the Godot editor was already open, close and reopen it so ClassDB sees native API renames."
