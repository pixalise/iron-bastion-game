# Pachingod North Star

Design working title: **Deck the Keep**

## Elevator Pitch

Pachingod is a physics-based roguelite where players build a magical siege
machine that manufactures a temporary deck of units and abilities before every
battle.

Players do not collect or draft cards directly. They buy unit balls and ability
balls, then engineer a pachinko machine that enhances, transforms, copies, and
resolves them. Pegs represent aspects, training, formations, physics, economy,
and special rules. Every bounce changes what the ball can become, and every
completed sequence creates cards for the upcoming battle.

The better the machine, the better the army.

## Core Promise

The player never drafts cards. The player builds a machine that creates cards.

Every ball is a recruit or spell core. Every bounce rewrites its fate.

The strategic focus is preparation: understand the coming battle, engineer the
right machine, and then use the deck that the machine produces.

## Core Gameplay Loop

### 1. Scout

Preview the next enemy wave:

- Enemy types
- Lane assignments
- Elite modifiers
- Boss mechanics

The player knows exactly what they are preparing for.

### 2. Shop

Spend Gold to improve the machine:

- Buy new pegs
- Buy new unit balls
- Buy new ability balls
- Buy aspect pegs
- Buy enhancement pegs
- Buy Kingdom buildings for bottom buckets
- Upgrade pegs
- Upgrade balls
- Upgrade enhancements
- Upgrade buildings
- Modify the board
- Reroll the shop
- Buy consumable balls

### 3. Engineer

Modify the board:

- Install a peg
- Remove a peg
- Move a peg
- Upgrade a peg
- Replace the ball loadout
- Unlock a socket
- Place or upgrade a building in a bottom bucket

### 4. Launch

Pull one lever and release the entire batch of balls into the machine.

During a launch:

- Balls bounce
- Pegs activate
- Sequences are recorded
- Cards are generated
- Resources are earned
- Bottom buckets resolve building bonuses
- The machine gains XP

The machine should become increasingly chaotic as the run progresses.

### 5. Level Up the Machine

The machine gains XP from:

- Peg hits
- Sequence completions
- Rare fusions
- Cascades
- Ball multipliers

Every level presents three upgrade choices. Example upgrades include:

- Extra Starting Balls
- Chain Reactions
- Better Splitters
- Double Activation
- Bonus Unit Balls
- Faster Ball Launcher
- Recipe Multiplier
- Bonus Portal
- Aspect Echo
- Critical Activations

Machine progression is independent of Gold. Gold represents purchasing power;
XP rewards effective use of the machine.

### 6. Combat

The machine disappears and the player uses the generated deck in a battle
across three independent lanes.

### 7. Rewards

Victory can grant:

- Gold
- A new peg
- A new unit or ability ball
- A new building
- An upgrade
- A recipe
- A relic

The player then scouts the next encounter and repeats the loop.

## Cards

There are only two card types.

### Units

Units are persistent battlefield pieces created by unit balls. Examples:

- Militia
- Archer
- Ashen Ranger
- Beast Warrior
- Golem
- Paladin

### Abilities

Abilities are one-time effects created by ability balls. Examples:

- Burning Volley
- Meteor
- Reinforcements
- Earthquake
- Blizzard
- Cannon Barrage

## Machine Language

The machine is composed of balls and pegs. Balls carry identity. Pegs modify,
transform, multiply, route, or reward that identity.

### Unit Balls

Unit balls are recruits. They are the primary source of unit cards.

Examples:

- Soldier Ball
- Archer Ball
- Pikeman Ball
- Knight Ball

Unit balls can have rarity, unlock state, and upgrade tracks. A rare unit ball
should feel like a better starting material, not just a larger number.

### Ability Balls

Ability balls are spell cores. They are the primary source of ability cards.

Examples:

- Meteor Strike Ball
- Target Practice Ball
- Reinforcements Ball
- Barrage Ball

Ability balls can be upgraded to improve spell power, targeting, area, repeat
behavior, or special effects.

### Aspect Pegs

Aspects are authored fantasy forces. They do not create generic adjective-unit
results by themselves. A unit or ability plus an aspect must resolve through an
authored recipe, or the aspect only contributes through its explicit modifiers.

Launch aspects start as a clear good-vs-dark structure: three Heroic Prime
Aspects and three Dark Prime Aspects. Each aspect owns three gameplay roles, so
the first set covers the fundamental launch space without implying these are
the only powers in the world.

Heroic Prime Aspects:

- Ember: aggression, sacrifice, burst
- Radiance: protection, restoration, order
- Wild: growth, mobility, numbers

Dark Prime Aspects:

- Blight: decay, attrition, infection
- Dread: fear, disruption, deception
- Dominion: control, suppression, fortification

Examples:

```text
Soldier Ball + Wild -> Beast Warrior
Archer Ball + Radiance -> Elven Archer
Meteor Strike Ball + Ember -> Cinderfall
Target Practice Ball + Dread -> False Orders
```

No generic "Wild Soldier" or "Radiance Archer" is created unless that result is
an authored unit or ability.

### Enhancement Pegs

Enhancements are simple, stackable modifiers applied to the final result after
identity is resolved.

Prototype enhancements:

- Attack Range: increases unit attack range
- Unit Increase: increases spawned unit count
- Damage Multiplier: multiplies unit or ability damage

Enhancements can be upgraded. Upgrades should make a peg meaningfully better or
more specialized, not merely add flat numbers forever.

Example upgrade paths:

- Attack Range becomes stronger for ranged units
- Unit Increase can create squad or battalion results
- Damage Multiplier becomes stronger when matching an aspect

### Physics Pegs

Physics pegs change how balls route through the machine:

- Spring
- Portal
- Splitter
- Accelerator
- Reflector
- Magnet

### Utility Pegs

Utility pegs produce economy:

- Gold
- Repair
- Upgrade Token
- Research

### Special Pegs

Special pegs introduce late-game mechanics:

- Echo
- Wildcard
- Memory
- Repeat
- Seal

## Sequence System

Every relevant ball and peg hit contributes to a sequence. Completed sequences
resolve into authored unit or ability results, then enhancements modify those
results.

Examples:

```text
Archer Ball + Radiance -> Elven Archer
Soldier Ball + Wild -> Beast Warrior
Meteor Strike Ball + Ember -> Cinderfall
Archer Ball + Unit Increase + Damage Multiplier -> stronger Archer Squad
```

Longer sequences unlock more specialized results, but longer is not always
stronger. Different encounters require different recipes and enhancements.

Recipes should stay authored. Aspects are not permutation generators. They are
ingredients that resolve to specific units or abilities when the recipe exists.

## Recipe Resolution

Recipes always resolve to an authored unit or authored ability. A recipe should
link to `result_unit` or `result_ability`, even when it uses a generic name and
description template.

The resolver works in this order:

1. Start with the ball identity.
2. Record aspect and enhancement peg hits.
3. Match the ordered recipe sequence.
4. Resolve to the authored unit or ability result.
5. Apply enhancement modifiers to the result.
6. Apply bottom bucket and building bonuses.

Aspects do not create free permutations. If `Archer Ball + Radiance` should make
Elven Archer, Elven Archer is an authored unit and the recipe points to it. If
`Meteor Strike Ball + Ember` should make Cinderfall, Cinderfall is an
authored ability and the recipe points to it.

Generic templates are still useful, but they describe result patterns rather
than inventing identities. For example, a recipe can use a Squad template or
Battalion template while still pointing to a specific authored unit.

## Tags and Modifiers

Tags are for eligibility and filtering, not for identity generation.

Examples:

- Ranged
- Melee
- Armored
- Spell
- Area
- Summon
- Aspect-born

Enhancement pegs use tags to decide what they can affect. Attack Range might
only affect Ranged units. Damage Multiplier might affect units and abilities.
Unit Increase only affects unit results.

## Bottom Buckets

The bottom of the board starts as a set of simple empty buckets. Early in a run,
balls falling into buckets only resolve the cards and resources already created
by the machine.

As the player earns Gold, buckets become valuable real estate. The Kingdom sells
buildings that can be installed in bottom buckets, turning the resolution layer
into another engineering decision instead of wasted board space.

Buildings do not replace the machine language. They modify the outcome after a
ball finishes its path.

Examples:

- Barracks: add Militia cards when a ball lands here
- Archery Range: copy the next Archer card generated this launch
- Treasury: convert bucket hits into extra Gold
- Workshop: add machine XP or upgrade tokens
- Chapel: improve Radiance recipes
- Market: improve shop rerolls or future building offers

Players can own multiple copies of the same building up to a per-building copy
cap. Copies let a player commit hard to a plan, while caps prevent one building
from consuming the whole bottom row forever.

Buildings can be upgraded. Upgrades should change behavior or scaling, not only
increase numbers. Example upgrades include:

- Wider bucket
- Double trigger on rare sequences
- Better reward when the landing ball has a matching aspect
- Add a specific symbol to the next sequence
- Store one unused trigger for the next launch

This makes the bottom of the board part of the machine. Balls and pegs define
the result. Buckets and buildings decide how valuable that result becomes when
the ball finally lands.

## Combat

Combat takes place across three independent lanes:

- Players spend generated cards
- Units occupy lanes
- Abilities create immediate effects

Combat is intentionally simple. The strategic complexity comes from scouting
the encounter and preparing the deck-producing machine.

## Balls

Balls are the starting material for cards. A unit ball wants to become a unit
card. An ability ball wants to become an ability card. Special balls bend the
machine or create economy.

Examples:

- Archer Ball
- Soldier Ball
- Pikeman Ball
- Meteor Strike Ball
- Target Practice Ball
- Split Ball
- Ghost Ball
- Lucky Ball
- Merchant Ball

Players build a batch before every launch. Later in a run, dozens of balls may
enter the machine simultaneously. The board does not ask, "Did I hit an Archer
peg?" It asks, "What happened to this Archer Ball while it traveled?"

## Economy and Progression

### Gold

Gold comes from combat and machine economy. The shop can sell:

- Unit balls
- Ability balls
- Special balls
- Pegs
- Peg upgrades
- Buildings
- Building upgrades
- Bucket unlocks
- Sockets
- Rerolls
- Temporary buffs
- Rare recipes

This creates meaningful decisions before every battle.

### Machine XP

Machine XP rewards effective machine use and drives upgrades during a run. The
goal is for every run to evolve from a small machine into a spectacular engine
of bouncing balls and cascading effects.

### Meta Progression

Runs unlock possibilities rather than simple stat increases:

- New pegs
- New balls
- New recipes
- New aspects
- New buildings
- New building upgrades
- New relics
- New board archetypes

## Board Archetypes

Different boards replace traditional character selection. A board is not
cosmetic: it changes layouts, mechanics, routing puzzles, and strategic
identity.

### Kingdom Board

The balanced standard machine, focused on reliable routing and traditional
fantasy units. This is the recommended beginner board.

### Infernal Board

Theme:

- Sacrifice
- Explosions
- Chaos

Mechanics:

- Blood pegs
- Hellfire
- Overheating
- High-risk routing

Example units:

- Demon Legionnaire
- Hell Mage
- Infernal Cannon

### Celestial Board

Theme:

- Precision
- Blessings
- Harmony

Mechanics:

- Mirrors
- Reflection
- Combo multipliers
- Repeated activations

Example units:

- Paladin
- Angel
- Guardian
- Elven Archer

### Nature Board

Theme:

- Growth
- Adaptation
- A living machine

Mechanics:

- Growing pegs
- Moving vines
- Seeds
- Regeneration

Example units:

- Druid
- Ent
- Wolf Pack
- Forest Guardian

### Arcane Board

Theme:

- Magic
- Space manipulation
- Complex routing

Mechanics:

- Portals
- Teleportation
- Echoes
- Sequence reversal
- Time manipulation

Example units:

- Archmage
- Arcane Construct
- Void Knight
- Spell Weaver

The player chooses which machine they want to master.

## Example Run

The player selects the Infernal Board.

The upcoming encounter contains:

- Armored Knights
- Goblin Swarm
- Demon Hunter Elite

The player buys two Archer Balls, a Split Ball, an Ember aspect peg, a Damage
Multiplier enhancement peg, and an Archery Range building for one bottom bucket.
Thirty balls flood the machine during the launch. Several split and begin a
chain reaction. Two Archer Balls hit Ember and the upgraded Archery Range
copies the best Archer result.

The machine generates:

- Ashen Ranger
- Ashen Ranger copy
- Beast Warrior
- Burning Volley
- Infernal Bombardment

The machine levels up and the player chooses Chain Reactions. Combat begins, the
generated deck defeats the wave, and the player earns Gold, new pegs, and a
building upgrade. The machine becomes more powerful for the next encounter.

## Prototype Scope

The first prototype must prove one idea:

> Building a machine that manufactures a tactical deck is fun.

Prototype content:

- One board: Kingdom
- Three unit ball identities
- Two ability ball identities
- Six aspects
- Three enhancement pegs
- Three physics pegs
- Three special ball types
- Four bottom buckets
- Six Kingdom buildings
- Approximately twelve recipes
- Twenty cards
- Three combat lanes
- Six enemy types
- Six battles
- One boss

Everything else comes after the core loop is validated.

## Product Guardrails

- The machine, not direct card drafting, is the deckbuilder.
- Scouting must provide enough information to engineer deliberately.
- Physics chaos must still produce understandable cause and effect.
- Bottom buckets should become meaningful strategic real estate, not passive
  score bins.
- Buildings should amplify machine results, not replace the machine as the
  source of cards.
- Aspects should resolve through authored recipes, not create automatic
  permutations.
- Combat supports the machine-building decisions instead of competing with
  them for complexity.
- New content should create routing, sequencing, or tactical possibilities
  rather than only increasing numbers.
- Meta progression should unlock new possibilities instead of flattening the
  challenge through permanent stat inflation.
- The first prototype should remain narrow until the machine-to-deck loop is
  demonstrably fun.

## Vision Statement

Pachingod combines the spectacle of pachinko with the strategic satisfaction of
engine-building and deck construction.

The player's greatest reward is not finding a rare card. It is watching a
carefully engineered machine erupt into controlled chaos, completing perfect
symbol chains and forging exactly the army they intended.

The machine is the deckbuilder.

The deck is the weapon.

The battle is the payoff.
