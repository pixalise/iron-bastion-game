# Graphite

Native C++ GDExtension simulation layer for Iron Bastion.

See [PHASE_PLAN.md](PHASE_PLAN.md) for the Phase 1 zoo POC and Phase 2
data-driven final-form plan.

## Build

Install the Godot C++ bindings into `graphite/godot-cpp`.

```sh
git clone https://github.com/godotengine/godot-cpp.git godot-cpp
```

### SCons

```sh
scons platform=linux target=template_debug arch=x86_64
```

### CMake / CLion

```sh
cmake -S . -B cmake-build-debug -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build cmake-build-debug
```

The shared library is written to `addons/graphite/bin`.

Godot loads `addons/graphite/graphite.gdextension` on startup. If the matching shared
library has not been built yet, Godot will fail fast with a missing dynamic library
error.

## CLion

Open the `graphite` directory as a CMake project:

```text
/home/brutus/Documents/IronBastion/iron-bastion/graphite
```

Use the `graphite` CMake target to build the extension.

For debugging, create a CLion run configuration with:

```text
Executable: godot
Program arguments: --path /home/brutus/Documents/IronBastion/iron-bastion
Working directory: /home/brutus/Documents/IronBastion/iron-bastion
Before launch: build graphite
```

## Smoke Usage

Once built and loaded by Godot:

```gdscript
var world := GraphiteWorld.new()
world.configure_simulation_grid(2, 2, 1.0)
world.set_simulation_cells(PackedByteArray([0, 1, 2, 16]))
assert(world.get_simulation_cell_count() == 4)
```
