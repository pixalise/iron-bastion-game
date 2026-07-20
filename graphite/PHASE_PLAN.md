# Graphite Phase Plan

Graphite is the native C++ simulation layer for Iron Bastion. It owns the
authoritative runtime facts of the battle: movement, combat, health, deaths,
commands, observations, and events.

Godot owns presentation: terrain visuals, scenes, animation, audio, VFX, UI,
selection, and camera.

Chisel owns authoring: unit definitions, assets, localization, validation, and
eventually the exported Graphite configuration.

The long-term goal is data-driven simulation, but the first goal is a boring,
playable zoo POC that proves the core loop.

## Core Rules

- Graphite is fail-fast. Invalid setup, missing configs, bad handles, impossible
  commands, and wrong buffer sizes should fail near the source.
- The simulation is data-oriented. Runtime systems operate over dense arrays,
  not per-agent object graphs.
- Godot-facing classes are thin. They convert Godot values into Graphite values
  and expose observations/events back to Godot.
- Graphite does not know about meshes, animations, sounds, VFX, icons, UI text,
  or localization.
- Dynamic runtime handles are not stable content IDs.
- Chisel/Godot stable IDs identify content. Graphite runtime handles identify
  spawned entities inside one simulation run.
- No config tables use null values. Use explicit profiles such as
  `NO_ABILITIES`, `NO_DEATH_EFFECT`, `NO_UPGRADES`, or empty arrays where an
  empty list is meaningful.

## Shared Concepts

### IDs

Stable content IDs come from Chisel/Godot exports:

```text
Unit.Id.RIFLE_MAN
Unit.Id.ZOMBIE
Unit.Id.ZOMBIE_EXPLODER
```

Graphite runtime handles are returned after spawning:

```text
AgentHandle
SquadHandle
HordeHandle
```

Use generational handles when practical:

```text
handle = generation << 32 | index
```

This lets Graphite reject stale handles after an agent dies and its slot is
reused.

### Navigation Cells

The first navigation primitive is a compact cell byte:

```cpp
using NavCell = std::uint8_t;

constexpr NavCell TerrainMask = 0x0f;    // bits 0..3
constexpr NavCell BlockedMask = 1u << 4; // bit 4
```

Suggested terrain values:

```text
0  Normal
1  Mud
2  Snow
3  Water
15 Unknown
```

The cell stores static terrain facts only. Dynamic occupancy should live in a
separate density or occupancy structure. Do not flip `BlockedMask` as agents
move.

## Phase 1: Zoo POC

Phase 1 is intentionally small. The goal is to prove that Godot can spawn units,
Graphite can simulate them, and Godot can render the returned state.

### Non-Goals

- No Chisel Graphite system tables yet.
- No data-driven upgrade trees.
- No veterancy implementation.
- No status effect system.
- No armor profile table.
- No commander abilities.
- No generalized attack-slot data model beyond the tiny hardcoded set.
- No final balance/config schema.
- No sophisticated pathfinding or flow fields.

### Phase 1 Folder Shape

```text
graphite/
  include/
    graphite/
      graphite_world.hpp
      graphite_types.hpp

  src/
    gdextension/
      register_types.cpp
      graphite_world_gd.cpp

    core/
      nav_cell.hpp
      navigation_grid.hpp
      navigation_grid.cpp
      agent_storage.hpp
      agent_storage.cpp
      sim_world.hpp
      sim_world.cpp
      hardcoded_unit_configs.hpp
      events.hpp
```

The current files already establish the Godot-facing shell. The next step is to
move actual simulation state into `src/core`.

### Phase 1 Hardcoded Unit Types

Use a tiny enum for the zoo:

```cpp
enum class UnitType : std::uint16_t {
	RifleMan,
	Zombie,
	ZombieExploder,
};
```

Use a small hardcoded config:

```cpp
struct UnitConfig {
	float radius;
	float max_health;
	float move_speed;

	float melee_damage;
	float melee_range;
	float melee_cooldown;

	float ranged_damage;
	float ranged_range;
	float ranged_cooldown;
	bool has_ranged;

	bool explodes_on_death;
	float explosion_damage;
	float explosion_radius;
};
```

Example values:

```text
RifleMan
  health: 100
  speed: 4.0
  melee: 6 damage, 1.2 range, 1.1 cooldown
  rifle: 12 damage, 18 range, 0.85 cooldown
  explodes: false

Zombie
  health: 35
  speed: 3.8
  melee: 8 damage, 1.1 range, 1.0 cooldown
  rifle: none
  explodes: false

ZombieExploder
  health: 25
  speed: 4.4
  melee: 4 damage, 1.0 range, 0.8 cooldown
  rifle: none
  explodes: true, 50 damage, 3.0 radius
```

Damage types can exist as a tiny enum in Phase 1:

```cpp
enum class DamageType : std::uint8_t {
	Melee,
	Ballistic,
	Explosion,
};
```

Do not implement armor/resistance yet. Still include `DamageType` in events so
Godot's rendering path starts with the right shape.

### Phase 1 Runtime Storage

Use structure-of-arrays storage:

```text
agent_generation[]
agent_type[]
agent_team[]
agent_x[]
agent_y[]
agent_vx[]
agent_vy[]
agent_health[]
agent_target[]
agent_move_target_x[]
agent_move_target_y[]
agent_melee_cooldown[]
agent_ranged_cooldown[]
agent_alive[]
```

This should support:

```text
500 player units
10000 zombie units
```

Keep the limits explicit and fail-fast when exceeded.

### Phase 1 Public API

The current `GraphiteWorld` already supports basic nav-grid setup. Grow it
toward this small zoo API:

```gdscript
var world := GraphiteWorld.new()

world.configure_navigation_grid(width, height, cell_size)
world.set_navigation_cells(cells)

var squad := world.create_squad(team_id)
var rifleman := world.spawn_agent(GraphiteUnit.RIFLE_MAN, team_id, Vector2(10, 10), squad)

var horde := world.create_horde(team_id)
world.spawn_horde(GraphiteUnit.ZOMBIE, 1000, team_id, Vector2(80, 80), horde)

world.command_squad_move(squad, Vector2(30, 30))
world.step(1.0 / 30.0)

var observations := world.get_agent_observations()
var events := world.drain_events()
```

If squads/hordes slow down early development, start even smaller:

```gdscript
spawn_agent(type, team, position)
set_agent_move_target(agent, position)
step(dt)
get_agent_observations()
drain_events()
```

Then add squads and hordes once individual agents can move and fight.

### Phase 1 Combat Rules

Use simple automatic behavior:

```text
1. If alive enemy is in melee range, use melee.
2. Else if unit has ranged attack and enemy is in ranged range, use ranged.
3. Else move toward current command target or nearest enemy.
4. If health reaches zero, mark dead and emit death event.
5. If exploder dies or triggers near an enemy, emit explosion and apply area damage.
```

No attack slots yet. Internally this can still look like "melee + optional
ranged" so that the later attack slot model has a natural migration path.

### Phase 1 Observations

Observations are the factual state Godot needs every frame or tick:

```text
agent_handle
unit_type
team
x
y
facing
health
max_health
alive
movement_state
action_state
```

For Phase 1, this can be a Godot `Array` of `Dictionary` values if that is
fastest to iterate on. Later, replace it with packed arrays or typed buffers.

### Phase 1 Events

Events are discrete things Godot should render:

```text
AgentSpawned
AttackStarted
DamageApplied
Explosion
AgentDied
```

Example event facts:

```text
DamageApplied
  source_agent
  target_agent
  damage_type
  amount
  target_health_after

Explosion
  source_agent
  x
  y
  radius
  damage_type
```

Godot decides what these look and sound like.

### Phase 1 Godot Rendering

Godot maintains the presentation map:

```gdscript
var visual_by_agent := {}
```

On spawn:

```gdscript
var scene := load(unit_presentation_scene_path)
var node := scene.instantiate()
add_child(node)
visual_by_agent[agent_handle] = node
```

On observation:

```gdscript
for observation in world.get_agent_observations():
	var node = visual_by_agent[observation.agent_handle]
	node.global_position = Vector3(observation.x, 0.0, observation.y)
	node.set_health(observation.health, observation.max_health)
	node.set_action_state(observation.action_state)
```

On event:

```gdscript
for event in world.drain_events():
	match event.type:
		"DAMAGE_APPLIED":
			spawn_hit_vfx(event.target_agent, event.damage_type)
		"EXPLOSION":
			spawn_explosion_vfx(event.x, event.y, event.radius)
		"AGENT_DIED":
			play_death(event.agent_handle)
```

### Phase 1 Completion Criteria

Phase 1 is done when:

- Godot can configure the nav grid.
- Godot can spawn riflemen and zombies.
- Agents move in the zoo.
- Zombies can damage riflemen in melee.
- Riflemen can damage zombies at range.
- Exploding zombies can apply area damage.
- Dead agents stop simulating.
- Godot renders position/health/death from Graphite observations/events.
- The zoo can run hundreds or thousands of zombies without changing the API.

## Phase 2: Final Data-Driven Form

Phase 2 starts after the zoo loop proves what the game actually needs. The goal
is to move hardcoded configs into Chisel and compile them into Graphite setup
data.

### Phase 2 Pipeline

```text
Chisel authoring data
  -> Chisel validation
  -> generated Godot data
  -> Godot registers Graphite configs
  -> Graphite validates and compiles dense runtime arrays
  -> Godot sends commands
  -> Graphite steps simulation
  -> Godot renders observations/events
```

Graphite defines what the simulation can do. Chisel exposes and validates those
capabilities. Godot presents the result.

### Phase 2 Ref Form

Chisel should store reusable referenced profiles:

```json
{
  "unit_types": [
    {
      "id": "RIFLE_MAN",
      "radius": 0.35,
      "max_health": 100,
      "movement_profile": "HUMAN_INFANTRY",
      "armor_profile": "LIGHT_INFANTRY_ARMOR",
      "attack_slot_profile": "RIFLE_MAN_ATTACK_SLOTS",
      "targeting_profile_group": "DIRECT_FIRE_INFANTRY_TARGETING",
      "default_targeting_profile": "NEAREST_ENEMY_DIRECT",
      "ability_loadout": "NO_ABILITIES",
      "death_effect": "NO_DEATH_EFFECT"
    }
  ]
}
```

The unit references profiles. The profiles contain the actual behavior data.

### Phase 2 Denormalized Form

Graphite does not need rich references during simulation. Export can compile
refs into denormalized or dense data:

```json
{
  "id": "RIFLE_MAN",
  "radius": 0.35,
  "max_health": 100,
  "movement": {
    "base_speed": 4.0,
    "acceleration": 12.0,
    "turn_speed": 8.0
  },
  "armor": {
    "flat_reduction": {
      "MELEE": 1.0,
      "BALLISTIC": 2.0
    },
    "multipliers": {
      "MELEE": 1.0,
      "BALLISTIC": 1.0,
      "FIRE": 1.25
    }
  },
  "attack_slots": [
    {
      "slot": "PRIMARY",
      "usage": "AUTO",
      "priority": 10,
      "attack": {
        "delivery": "RAY",
        "area_shape": "NONE",
        "range": 18.0,
        "cooldown": 0.85,
        "damage": [
          { "type": "BALLISTIC", "amount": 12.0 }
        ]
      }
    },
    {
      "slot": "MELEE",
      "usage": "AUTO_WHEN_IN_RANGE",
      "priority": 50,
      "attack": {
        "delivery": "MELEE",
        "area_shape": "NONE",
        "range": 1.2,
        "cooldown": 1.1,
        "damage": [
          { "type": "MELEE", "amount": 7.0 }
        ]
      }
    }
  ]
}
```

The final internal form should be denser than JSON:

```text
unit_radius[]
unit_max_health[]
unit_movement_profile[]
unit_armor_profile[]
unit_attack_slot_start[]
unit_attack_slot_count[]

attack_slot_profile[]
attack_slot_usage[]
attack_slot_priority[]

attack_delivery[]
attack_range[]
attack_cooldown[]
attack_damage_start[]
attack_damage_count[]

damage_component_type[]
damage_component_amount[]
```

### Phase 2 System Tables

Likely Chisel system tables:

```text
graphite_damage_types
graphite_movement_profiles
graphite_armor_profiles
graphite_attack_profiles
graphite_attack_slot_profiles
graphite_targeting_profiles
graphite_targeting_profile_groups
graphite_ability_loadouts
graphite_ability_profiles
graphite_death_effects
graphite_modifier_profiles
```

User-facing unit tables reference these system profiles.

### Phase 2 Attack Slots

Final-form units should support multiple attack slots because Iron Bastion will
have mechs and universal melee fallbacks.

```json
{
  "id": "LIGHT_MECH_ATTACK_SLOTS",
  "slots": [
    {
      "slot": "LEFT_ARM",
      "attack_profile": "MECH_AUTOCANNON",
      "usage": "AUTO",
      "priority": 10,
      "cooldown_group": "LEFT_ARM"
    },
    {
      "slot": "RIGHT_ARM",
      "attack_profile": "MISSILE_POD",
      "usage": "AUTO",
      "priority": 8,
      "cooldown_group": "RIGHT_ARM"
    },
    {
      "slot": "MELEE",
      "attack_profile": "MECH_STOMP",
      "usage": "AUTO_WHEN_IN_RANGE",
      "priority": 50,
      "cooldown_group": "MELEE"
    }
  ]
}
```

Attack slots answer how a unit owns/uses an attack. Attack profiles answer what
the attack does.

### Phase 2 Abilities

Commander units and special mechs can have abilities. Keep abilities separate
from automatic attack slots:

```text
Attack slots = automatic combat loop
Abilities = explicit commanded actions
```

Example:

```json
{
  "id": "FIELD_COMMANDER_ABILITIES",
  "abilities": [
    "RALLY_SQUAD",
    "SMOKE_BARRAGE"
  ]
}
```

Graphite validates:

```text
agent exists
agent is alive
agent has ability
ability is off cooldown
target is legal
target is in range
```

Godot renders:

```text
button cooldowns
targeting reticles
voice lines
VFX
```

### Phase 2 Targeting Modes

Player squads need HUD-switchable targeting. Do not make targeting nullable.
Every unit has:

```text
default_targeting_profile
targeting_profile_group
```

The HUD switches the active squad targeting profile:

```gdscript
world.set_squad_targeting_profile(squad, TargetingProfile.Id.HOLD_FIRE)
```

Graphite validates that the selected profile is allowed for the squad.

### Phase 2 Damage, Armor, and Statuses

Damage types should be first-class:

```text
Melee
Ballistic
Explosive
Fire
Acid
```

Attacks can contain multiple damage components:

```json
{
  "id": "ACID_BURST",
  "delivery": "SELF_DESTRUCT",
  "area_shape": "CIRCLE",
  "splash_radius": 4.0,
  "damage": [
    { "type": "EXPLOSIVE", "amount": 65.0 },
    { "type": "ACID", "amount": 20.0 }
  ],
  "statuses": [
    { "status": "ARMOR_CORRODED", "chance": 1.0, "duration": 6.0 }
  ]
}
```

Armor can start with:

```text
final_damage = max(0, raw - flat_reduction) * multiplier
```

Status effects should be delayed until after Phase 1 unless they are required by
the first zoo enemies.

### Phase 2 Specialization, Upgrades, and Veterancy

Specialization upgrades can mostly live outside Graphite:

```text
RIFLE_MAN -> RIFLE_MAN_AP_SPECIALIST
MECH -> MECH_MISSILE_LOADOUT
```

Godot/Chisel chooses the replacement. Graphite applies it:

```gdscript
world.replace_squad_unit_type(squad, Unit.Id.RIFLE_MAN_AP_SPECIALIST)
```

Graphite preserves runtime state according to explicit rules:

```text
position preserved
squad membership preserved
target preserved if still legal
health ratio preserved
cooldowns reset or remapped by slot
statuses preserved or cleared by policy
```

Simple stat upgrades and veterancy bonuses can become generic modifiers:

```json
{
  "id": "ARMOR_UP_1",
  "scope": "SQUAD",
  "target": "ARMOR",
  "stat": "BALLISTIC_FLAT_REDUCTION",
  "op": "ADD",
  "value": 2.0
}
```

Chisel/Godot owns:

```text
upgrade tree
costs
unlock conditions
veterancy XP thresholds
which replacement or modifier to apply
```

Graphite owns:

```text
replace unit type
apply/remove modifier profile
recompute effective stats
simulate
```

### Phase 2 Public API Direction

GraphiteWorld can grow toward:

```text
register_unit_type(stable_unit_id, config)
register_modifier_profile(stable_modifier_id, config)

create_squad(team_id)
create_horde(team_id)

spawn_agent(unit_type_id, team_id, position, controller)
spawn_squad(unit_type_id, count, team_id, position)
spawn_horde(unit_type_id, count, team_id, position)

command_squad_move(squad, target)
command_squad_attack_move(squad, target)
set_squad_targeting_profile(squad, targeting_profile)
activate_ability(agent, ability_id, target)

replace_agent_unit_type(agent, unit_type_id)
replace_squad_unit_type(squad, unit_type_id)
apply_squad_modifier(squad, modifier_id)
remove_squad_modifier(squad, modifier_handle)

step(fixed_dt)
get_agent_observations()
drain_events()
```

Add this API in slices. Do not implement the whole list before the zoo proves
the basics.

### Phase 2 Completion Criteria

Phase 2 is done when:

- Unit sim profiles are authored in Chisel.
- Chisel validates all Graphite refs and no-null rules.
- Godot exports/registers configs into Graphite.
- Graphite compiles configs into dense runtime arrays.
- Squads and hordes use the same agent storage.
- Player squads support HUD targeting modes.
- Units support multiple attack slots.
- Commander abilities can be commanded and produce events.
- Damage types and armor profiles affect combat.
- Specialization replacement works.
- Simple squad modifiers work.
- Godot rendering remains presentation-only.

## Development Bias

Build Phase 1 with the minimum hardcoded data needed to make the zoo feel alive.
Only promote a concept into Chisel once the zoo has proven the concept belongs
in the game.

The final form should be boring and data-driven. The POC should be boring and
hardcoded. The mistake to avoid is building final-form data machinery before the
sim loop is fun.
