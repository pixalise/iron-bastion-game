#!/usr/bin/env python3
"""Parse GDScript files with the local Godot CLI."""

from __future__ import annotations

import subprocess
import sys
import os
from pathlib import Path


def project_root() -> Path:
    current = Path.cwd()
    if (current / "project.godot").is_file():
        return current

    for parent in current.parents:
        if (parent / "project.godot").is_file():
            return parent

    raise RuntimeError("Could not find project.godot in the current directory or its parents.")


def main() -> int:
    root = project_root()
    files = [Path(path) for path in sys.argv[1:] if path.endswith(".gd")]
    failures = 0
    env = os.environ.copy()
    godot_home = Path("/tmp/iron-bastion-godot-pre-commit")
    for key, value in {
        "HOME": godot_home / "home",
        "XDG_CACHE_HOME": godot_home / "cache",
        "XDG_CONFIG_HOME": godot_home / "config",
        "XDG_DATA_HOME": godot_home / "data",
    }.items():
        value.mkdir(parents=True, exist_ok=True)
        env[key] = str(value)

    for script_path in files:
        result = subprocess.run(
            ["godot", "--headless", "--check-only", "--script", str(script_path)],
            cwd=root,
            check=False,
            env=env,
            text=True
        )
        if result.returncode != 0:
            failures += 1

    return 1 if failures else 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except RuntimeError as error:
        print(error, file=sys.stderr)
        raise SystemExit(1)
