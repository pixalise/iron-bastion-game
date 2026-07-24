# Pachingod North Star

Design working title: **Deck the Keep**

## Elevator Pitch

Pachingod is a physics-based roguelite where players build a magical siege
machine that manufactures a temporary deck of units and abilities before every
battle.

Players do not collect or draft cards directly. They engineer a pachinko
machine by installing modules, elemental runes, physics components, and special
balls. Every bounce contributes to a sequence, and every completed sequence
creates cards for the upcoming battle.

The better the machine, the better the army.

## Core Promise

The player never drafts cards. The player builds a machine that creates cards.

Every bounce writes a sentence. Every sentence becomes a tactical option.

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

- Buy new modules
- Buy new balls
- Buy Kingdom buildings for bottom buckets
- Upgrade modules
- Upgrade buildings
- Modify the board
- Reroll the shop
- Buy consumable balls

### 3. Engineer

Modify the board:

- Install a module
- Remove a module
- Move a module
- Upgrade a module
- Replace the ball loadout
- Unlock a socket
- Place or upgrade a building in a bottom bucket

### 4. Launch

Pull one lever and release the entire batch of balls into the machine.

During a launch:

- Balls bounce
- Modules activate
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
- Bonus Fire Balls
- Faster Ball Launcher
- Recipe Multiplier
- Bonus Portal
- Elemental Echo
- Critical Activations

Machine progression is independent of Gold. Gold represents purchasing power;
XP rewards effective use of the machine.

### 6. Combat

The machine disappears and the player uses the generated deck in a battle
across three independent lanes.

### 7. Rewards

Victory can grant:

- Gold
- A new module
- A new ball
- A new building
- An upgrade
- A recipe
- A relic

The player then scouts the next encounter and repeats the loop.

## Cards

There are only two card types.

### Units

Units are persistent battlefield pieces. Examples:

- Militia
- Archer
- Fire Archer
- Frost Knight
- Golem
- Paladin

### Abilities

Abilities are one-time effects. Examples:

- Burning Volley
- Meteor
- Reinforcements
- Earthquake
- Blizzard
- Cannon Barrage

## Machine Language

The machine is composed of symbols. Modules represent concepts rather than
buildings, and each module hit appends its symbol to the current sequence.

### Class Modules

Class modules form the foundation of generated cards:

- Soldier
- Archer
- Mage
- Siege
- Engineer
- Priest
- Beast

### Element Modules

Elements modify classes:

- Fire
- Ice
- Earth
- Storm
- Nature
- Shadow
- Holy
- Arcane

### Physics Modules

Physics modules change how balls route through the machine:

- Spring
- Portal
- Splitter
- Accelerator
- Reflector
- Magnet

### Utility Modules

Utility modules produce economy:

- Gold
- Repair
- Upgrade Token
- Research

### Special Modules

Special modules introduce late-game mechanics:

- Echo
- Wild
- Memory
- Repeat
- Seal

## Sequence System

Every module hit appends a symbol. Completed symbol sequences resolve into
cards.

Examples:

```text
Fire -> Archer -> Fire Archer
Ice -> Soldier -> Frost Knight
Fire -> Archer -> Archer -> Burning Volley
Earth -> Engineer -> Siege -> Fortified Bombardment
```

Longer sequences unlock more specialized cards, but longer is not always
stronger. Different encounters require different recipes.

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
- Chapel: improve Holy or Priest recipes
- Market: improve shop rerolls or future building offers

Players can own multiple copies of the same building up to a per-building copy
cap. Copies let a player commit hard to a plan, while caps prevent one building
from consuming the whole bottom row forever.

Buildings can be upgraded. Upgrades should change behavior or scaling, not only
increase numbers. Example upgrades include:

- Wider bucket
- Double trigger on rare sequences
- Better reward when the landing ball has a matching element
- Add a specific symbol to the next sequence
- Store one unused trigger for the next launch

This makes the bottom of the board part of the machine. Pegs and modules define
the sentence. Buckets and buildings decide how valuable the sentence becomes
when the ball finally lands.

## Combat

Combat takes place across three independent lanes:

- Players spend generated cards
- Units occupy lanes
- Abilities create immediate effects

Combat is intentionally simple. The strategic complexity comes from scouting
the encounter and preparing the deck-producing machine.

## Balls

Balls are ammunition for the machine. Examples:

- Basic Ball
- Heavy Ball
- Fire Ball
- Ice Ball
- Split Ball
- Ghost Ball
- Lucky Ball
- Merchant Ball

Players build a batch before every launch. Later in a run, dozens of balls may
enter the machine simultaneously.

## Economy and Progression

### Gold

Gold comes from combat and machine economy. The shop can sell:

- Balls
- Modules
- Module upgrades
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

- New modules
- New balls
- New recipes
- New elements
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

- Blood modules
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
- Holy Archer

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

The player buys a Fire Ball, a Split Ball, a new Archer module, and an Archery
Range building for one bottom bucket. Thirty balls flood the machine during the
launch. Several split and begin a chain reaction. Two balls land in the upgraded
Archery Range, copying the best Archer results.

The machine generates:

- Fire Archer
- Fire Archer copy
- Hell Knight
- Burning Volley
- Infernal Bombardment

The machine levels up and the player chooses Chain Reactions. Combat begins, the
generated deck defeats the wave, and the player earns Gold, new modules, and a
building upgrade. The machine becomes more powerful for the next encounter.

## Prototype Scope

The first prototype must prove one idea:

> Building a machine that manufactures a tactical deck is fun.

Prototype content:

- One board: Kingdom
- Four class modules
- Three elements
- Three physics modules
- Three ball types
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
