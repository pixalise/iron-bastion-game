# Project Black Lantern North Star

## Purpose

This document defines the identity of Project Black Lantern and the principles that guide product, design, art, engineering, and scope decisions.

The Game Design Document contains the detailed rules and content framework. This North Star is the shorter decision filter: when a feature strengthens the promises below, it belongs; when it weakens or distracts from them, it does not.

## Elevator Pitch

Project Black Lantern is an illustrated extraction roguelite where the player's physical loadout is the deckbuilding interface.

Equipped gear creates a functional nine-card core deck. Items placed in the backpack use visible spatial relationships to transform those cards, activate passives, unlock exploration options, and add no more than six additional cards.

Every expedition asks one defining question:

> Do I extract now and secure what I have built, or risk another floor for a stronger haul?

## Core Promise

Everything the player can do comes from something they visibly carry.

The sword explains the attack card. The shield explains the defensive option. The lantern reveals a route. The rope opens a traversal choice. The placement of those objects explains how the build changes.

The player should always be able to point to the equipment, item, or physical relationship responsible for a card, passive, transformation, or contextual action.

## The Defining Relationship

- Equipment defines who the player is.
- Backpack placement defines how cleverly the player uses what they carry.
- Synergies define what the build becomes.
- The dungeon gives those objects context.
- Extraction determines whether the expedition's gains become permanent.

Project Black Lantern is not a conventional deckbuilder with an inventory attached. The physical loadout is the deckbuilding system.

## Player Fantasy

The player should feel like a prepared but vulnerable dungeon delver who:

- Enters a dangerous place with a deliberately packed kit
- Reads sensory clues and makes informed decisions
- Finds a physical item and immediately understands how it could change the build
- Rotates and repositions items to create compact, traceable engines
- Uses the same equipment to solve combat, traversal, and narrative problems
- Decides when greed is worth risking unsecured loot
- Leaves each run with a story, not only a score

## Design Pillars

### 1. Discovery Before Commitment

The dungeon is understood gradually through grid visibility, environmental clues, illustrated events, and spatial memory.

Players should often learn something useful before choosing a route or entering combat. Mystery concerns the exact outcome, not whether a decision matters.

**Design test:** Does the player learn something before committing?

### 2. Physical Buildcraft

Cards, passives, transformations, and exploration verbs come from visible equipment and backpack relationships.

Inventory placement is a spatial puzzle with real opportunity cost. It is not a passive-stat spreadsheet, a second hand, or an auto-battler board.

**Design test:** Can the player point to the object or relationship causing the effect?

### 3. Compact Tactical Decks

The prepared deck begins with exactly nine functional core cards and never exceeds fifteen cards.

Adding a card is not automatically an upgrade. Every addition competes with consistency, while transformations and passives offer power without deck growth.

**Design test:** Does every added card justify making the deck less consistent?

### 4. Risk Versus Extraction

Success is not limited to defeating a boss. Extracting useful loot at the right moment is a legitimate and strategically meaningful ending.

Deeper floors offer stronger rewards, but unsecured gains remain vulnerable until extraction.

**Design test:** Is continuing tempting and genuinely dangerous?

### 5. Unified Systems

Items should create decisions across combat and exploration instead of existing only as numerical upgrades.

The map, events, inventory, deck, and extraction economy must reinforce one another as a single expedition loop.

**Design test:** Does this reward create choices beyond dealing more damage?

## The Central Decision

At the end of each meaningful expedition segment, the player should be asking:

> Is the expected value of going deeper worth risking what I have not yet secured?

This tension requires:

- Loot valuable enough to create attachment
- Danger legible enough to support judgment
- Extraction routes visible or discoverable before the player is trapped
- Builds that become more capable without becoming invulnerable
- Loss meaningful enough to create tension without erasing the desire to experiment

## Core Gameplay Loop

### 1. Prepare

Choose a hero and starting equipment, pack the backpack, inspect active relationships, and review the resulting nine-to-fifteen-card deck.

The nine-card equipment deck must already function. Backpack synergies specialize or transform it; they do not rescue an unusable loadout.

### 2. Explore

Move one orthogonal square at a time through a dungeon floor. Read fog-of-war states, room types, environmental changes, and discovered routes.

The map supports route planning and spatial memory. It is not a decorative node graph.

### 3. Interpret

Read short illustrated events, notice sensory evidence, and choose between caution, greed, force, knowledge, or sacrifice.

Requirements and known risks should be clear enough for informed decisions. Equipment and backpack keywords can unlock contextual choices.

### 4. Fight

Enter fast, turn-based combat using the compact deck generated by the current physical loadout.

Enemy intent, hand state, energy, status effects, and the source of every card must remain readable. Sequencing matters, but combat must not overwhelm exploration as the game's only meaningful activity.

### 5. Loot and Repack

Gain equipment, components, tools, consumables, relics, treasure, and cursed objects. Decide whether each item is valuable for the current build, worth its physical space, or better discarded.

Repositioning an item should immediately preview cards gained or transformed, passives activated, exploration verbs unlocked, and conflicts created.

### 6. Extract or Descend

Leave through an extraction point to secure the haul, or continue to a more dangerous floor for stronger rewards.

Death loses unsecured gains according to the active protection rules. Boss victory is valuable, but it is not the only valid measure of success.

```text
Prepare -> Explore -> Interpret -> Fight -> Loot and Repack -> Extract or Descend
```

## Exploration Model

Prototype floors use a 6x6 square grid. The broader design may grow to 8x8 where content density and route readability support it.

Movement is orthogonal by default. Each tile represents a meaningful room, chamber, street segment, or clearing rather than literal walking distance.

Fog of war uses clear information states:

- **Unknown:** no reliable information
- **Sensed:** a broad category, sound, smell, track, or danger clue
- **Revealed:** room type, exits, and resolved state are visible
- **Altered:** the room visibly changed because of an event, enemy, or environmental effect

Exploration is not taxed by a universal stamina meter. Pressure comes from local, understandable systems such as light, pursuit, infection, floor alert, collapsing routes, or environmental hazards.

## Illustrated Event Model

An event presents:

- One strong illustration focused on mood and actionable objects
- A short description, normally 35 to 90 words
- Two to four visible choices
- Clear item, keyword, or known-risk requirements where applicable
- Outcomes that can alter state, resources, inventory, deck, map, or narrative flags

Writing leads with sensory evidence rather than lore exposition. Each event should contain one striking visual and one actionable uncertainty.

## Equipment-Generated Core Deck

Equipped gear and the hero ability always generate exactly nine core cards.

The baseline contribution is:

- Weapon: four cards
- Off-hand: two cards
- Armor: two cards
- Hero ability: one card

Tools and trinkets primarily provide exploration verbs, passives, and synergy hooks. They do not casually inflate the core deck.

Equipment families must communicate understandable play patterns. Upgrades should often transform existing cards instead of adding invisible percentages or unnecessary deck volume.

## Backpack Synergy Engine

The starting backpack target is 4x4 cells. Items occupy readable shapes and may be rotated unless intentionally orientation-locked.

Relationships use simple physical language:

- Adjacent
- Same row
- Same column
- Between
- Touches equipment socket
- Named set
- Keyword count

Valid synergy outputs are:

- Add a card, up to the fifteen-card cap
- Add a small linked card package
- Transform an existing card
- Activate a passive
- Unlock an exploration ability

Relationships resolve deterministically. Every result must remain visually traceable, and the game must explain disabled, conflicting, or overflowing effects.

## Combat Promise

Combat is turn-based, readable, and fast enough that exploration remains equally important.

Prototype baselines are a five-card hand and three energy per turn. Enemy intents clearly communicate damage and primary effects. Compact decks reward sequencing and planning several actions ahead.

Combat should make the player's physical preparation visible. Hovering or inspecting a card must reveal the equipment or backpack relationship that generated it.

## Extraction and Progression

Items and currency found during an expedition remain unsecured until extraction.

At least one reliable extraction opportunity appears before the first major difficulty spike. Other routes may be hidden, temporary, costly, or enabled by items, but the player must receive warning before a known route closes.

Permanent progression expands strategic possibility more than raw numerical power. It unlocks new heroes, equipment families, backpack components, regions, events, relationships, and knowledge without making early content trivial through permanent stat inflation.

The between-run structure may include a stash, workshop, cartographer, quartermaster, and codex, but the expedition loop must be fun before the hub expands.

## Screen and Presentation Model

### Exploration

- Left: grid map, fog of war, sensed clues, and route state
- Center/right: illustration, concise room description, and choices
- Persistent panel: equipped items, backpack layout, burden, and active synergies
- Top status: region, floor, light or alert, and relevant resources
- Tooltip layer: source tracing for cards, passives, and contextual actions

### Combat

- Enemy art and intent dominate the center
- The hand occupies the lower center
- Draw and discard counts remain visible
- Equipment and relevant backpack synergies remain visible
- Hovering a card highlights its physical source

The target visual direction is hand-painted dark fantasy with readable silhouettes, warm parchment interfaces, tactile inventory objects, and map tiles that resemble inked cartography rather than glowing abstract nodes.

## Prototype Experience Goal

The first prototype must prove one idea:

> Building a compact deck through visible equipment and backpack placement is understandable and enjoyable, and extraction makes that build emotionally valuable.

The prototype must test whether players:

- Enjoy rearranging the backpack after the novelty wears off
- Understand why every card and passive exists
- Experience meaningful consistency tradeoffs across the nine-to-fifteen-card range
- Use exploration clues to prepare and choose routes
- Reject individually powerful loot when it harms the current build
- Voluntarily extract before a boss when the risk becomes too high

## Greybox Prototype Scope

The first complete proof contains:

- One 6x6 dungeon generator
- One hero
- Three equipment loadouts
- Twenty backpack items using adjacency and named-set rules
- Twenty-five cards
- Six enemies
- One boss
- Twelve text events with placeholder illustrations
- Extraction from floor one or descent to floor two

This is a validation build, not a miniature content-complete release.

## Prototype Definition of Done

A new tester can, without developer explanation:

1. Choose a loadout and identify the source of all nine core cards
2. Pack and rotate items in the backpack
3. Understand which relationships are active and what they produce
4. Move through a 6x6 dungeon using fog, clues, and revealed routes
5. Resolve at least one item-enabled illustrated choice
6. Complete turn-based combat using visible enemy intents
7. Loot an item and make a meaningful keep, discard, or reposition decision
8. See the deck and passives update immediately after a loadout change
9. Find an extraction route
10. Choose either to secure the haul or risk descending to floor two
11. Understand what was lost or secured when the run ends

Placeholder art is acceptable. Untraceable rules and unclear cause-and-effect are not.

## Required Telemetry

Record:

- Average prepared deck size by depth
- Added cards rejected at the cap
- Synergy activation frequency
- Time spent packing
- Item moves, rotations, and removals
- Exploration clue usage
- Event choice distribution
- Extraction depth distribution
- Deaths with a known extraction route available
- Secured and unsecured loot value
- Card and passive source-inspection frequency

Telemetry exists to test clarity, buildcraft, and risk decisions. It is not an engagement-maximization system.

## Non-Negotiable Principles

- Equipped gear and the hero generate exactly nine core cards
- The prepared deck never exceeds fifteen cards
- The nine-card core works without backpack synergies
- Backpack effects are cards, transformations, passives, or exploration verbs, not generic stat soup
- Every effect is visually traceable to an item or relationship
- Grid exploration and short illustrated choices remain the primary discovery format
- Extraction is a meaningful strategic ending, not merely a portal after the boss
- Items create decisions across combat and exploration
- Information supports judgment before commitment
- Inventory space and deck consistency remain real costs
- New content does not compensate for a weak core loop

## Product Guardrails

- Do not turn the game into a conventional deckbuilder with a disconnected inventory
- Do not introduce a remote card collection that replaces physical loadout construction
- Do not let backpack management become a passive-stat spreadsheet
- Do not hide the source of cards, passives, transformations, or contextual actions
- Do not allow infinite generation or recursive synergy loops
- Do not make every item correct for every build
- Do not let combat erase exploration, events, packing, or extraction as equal parts of the experience
- Do not make boss victory the only valid run outcome
- Do not punish exploration with an unexplained universal movement tax
- Do not scale content volume before the signature loop is proven

## Legacy Direction Removed

Project Black Lantern is a new game. The following systems belong to the previous concept and are not part of this direction:

- Pachinko machines
- Ball dropping, regeneration, and physics production
- Productive building pegs
- Kingdom resources and construction projects
- Real-time one-lane combat
- Castle defense
- Timed enemy waves
- Unit deployment
- Pachinko-driven abilities

Legacy code, data, documentation, naming, and assets that exist only for those systems should not influence new design decisions and may be removed as the project is migrated.

## Vision Statement

Project Black Lantern combines the tension of extraction, the clarity of compact tactical decks, the satisfaction of physical inventory puzzles, and the atmosphere of illustrated dungeon exploration.

The equipment is the identity.

The backpack is the buildcraft.

The dungeon is the test.

Extraction is the decision that makes every discovery matter.
