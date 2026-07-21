#!/usr/bin/env bash
set -euo pipefail

build_dir="graphite/cmake-build-debug"
compile_commands="${build_dir}/compile_commands.json"

if [[ ! -f "${compile_commands}" ]]; then
	echo "Missing ${compile_commands}. Run Graphite CMake configure before clang-tidy." >&2
	exit 1
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

sed 's/ -fno-gnu-unique//g' "${compile_commands}" > "${tmp_dir}/compile_commands.json"

clang-tidy -p "${tmp_dir}" "$@"
