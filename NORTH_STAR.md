# Pachinko Kingdom North Star

## Elevator Pitch

Pachinko Kingdom is a real-time strategy roguelite where a pachinko machine is the kingdom's lifeline.

Balls striking building pegs produce the resources needed to deploy units, construct defenses, complete kingdom projects, and charge active abilities. Those choices immediately affect a one-lane battlefield running beside the machine.

The player must constantly decide whether to aim the next balls at surviving the current attack or invest in a stronger kingdom for the next one.

## Core Promise

The pachinko machine powers a living battlefield.

Every ball creates immediate, readable consequences. Where the player launches it determines what the kingdom can afford, and what the kingdom can afford determines whether it survives.

The player is not building or drawing a deck. The player is operating a production machine under pressure.

## Prototype Experience Goal

The first prototype must prove one idea:

> Producing resources through pachinko while making real-time battlefield decisions is fun.

A successful prototype makes the player feel like they are operating the kingdom's lifeline. The machine and battlefield must form one feedback loop, not two unrelated games sharing a screen.

The player should understand:

- Which building pegs produce which resources
- Which battlefield actions those resources enable
- Why the next enemy wave changes where they should aim
- When manual dropping is worth spending stored balls
- When auto-drop is sufficient
- When to defend immediately and when to invest in future strength

## The Central Decision

At any moment, the player should be asking:

> Do I use my next balls to survive the current pressure, or invest in a stronger kingdom for the next pressure spike?

Immediate survival includes producing units, counters, repairs, and emergency ability charge. Longer-term investment includes projects, structures, peg improvements, and production upgrades. Neither choice should always be correct.

## Core Gameplay Loop

The machine and battlefield run at the same time.

### 1. Read the Threat

The player sees the active battle and a telegraph of the next enemy wave:

- Enemy composition and arrival timing
- Important traits and suggested counters
- Boss mechanics when relevant

Scouting exists to create deliberate production decisions.

### 2. Aim and Launch

The player moves a launcher above the pachinko board and releases balls. The launcher supports manual aiming, manual burst dropping, a limited magazine, passive regeneration, and optional auto-drop.

Manual control is faster and more deliberate. Auto-drop prevents idle production but should not replace player judgment.

### 3. Produce

Balls strike building pegs and produce resources immediately. Every hit must clearly show which peg activated, what it produced, and which action became closer to affordable.

### 4. Spend

Without leaving the main screen, the player can:

- Deploy a unit
- Build or repair a defensive structure
- Advance a kingdom project
- Activate an ability when charged

Spending must be fast. The strategy is deciding what to afford, not navigating menus.

### 5. Fight

Units enter one horizontal lane and fight automatically. The player chooses the composition, maintains a frontline, protects ranged units, counters enemy traits, and times active abilities.

Combat creates the demand that gives pachinko production meaning.

### 6. Improve

Between waves and through level-ups, the player may move, upgrade, or replace a peg; improve ball capacity or regeneration; select a project; or choose a production specialization.

Improvements must affect decisions within the same run.

### 7. Survive

A prototype run contains six escalating waves and a boss. Victory comes from defeating the boss before the castle is destroyed.

```text
Read threat -> Aim -> Produce -> Spend -> Fight -> Improve
```

## Screen and Attention Model

The complete core game remains visible on one screen.

### Left: Pachinko Machine

Roughly 38 percent of the screen contains:

- Sliding launcher
- Eight peg rows
- Productive and neutral pegs
- Ball magazine and regeneration timer
- Manual drop and auto-drop controls
- Ball cleanup area

### Right: Kingdom and Battlefield

Roughly 62 percent contains:

- Player castle and friendly deployment point
- One combat lane and enemy spawn point
- Fixed defensive structure slots
- Unit deployment and ability controls
- Current and upcoming threat information

### Shared Status

The shared interface shows Food, Gold, Weapons, Military Readiness, Construction, Ability Charge, XP, level, castle health, and wave timing.

During normal pressure, pachinko aiming and dropping should receive about half of the player's attention. If players mostly watch combat, the machine lacks agency. If players ignore combat, battlefield feedback is not influencing production.

## Pachinko Machine

### Balls

Balls are production opportunities, not identities or future units.

Prototype rules:

- The magazine starts with five balls
- One ball regenerates every 2.5 seconds
- Manual drops have a 0.25-second lockout
- Auto-drop initially uses a 3.5-second cadence
- Balls have a finite lifetime and cannot remain permanently stuck

The base prototype uses one standard ball. One experimental Heavy Ball may be tested as an upgrade, but additional ball families are outside the first content lock.

### Launcher

The player moves horizontally to influence which peg clusters a ball reaches. Similar launches should feel learnable without becoming completely deterministic. Physics creates variation, but player intent must remain visible.

### Board

The prototype board contains eight rows and 36 positions:

- 24 productive building pegs
- 12 neutral physics pegs

The starting productive layout is:

- 6 Farm pegs
- 6 Barracks pegs
- 3 Blacksmith pegs
- 3 Treasury pegs
- 4 Workshop pegs
- 2 Ability Shrine pegs

The layout should create recognizable production neighborhoods so aiming has meaning.

### Peg Management

Between waves, the player receives one clear action:

- Move one peg
- Upgrade one peg
- Replace one neutral peg with a basic building peg

Peg management improves production control without introducing a separate engineering phase or inventory.

## Building Pegs and Resources

Building pegs are the machine's productive vocabulary.

### Farm: Food

Food supports frequent unit deployment and should be the most immediately understandable resource.

### Barracks: Military Readiness

Readiness represents the kingdom's ability to mobilize units.

### Blacksmith: Weapons

Weapons enable stronger or specialized units, especially counters to armored threats.

### Treasury: Gold

Gold supports advanced deployments, structures, and kingdom investments.

### Workshop: Construction

Construction repairs defenses, builds structures, and advances the active kingdom project.

### Ability Shrine: Ability Charge

Charge powers active interventions such as Arrow Rain and Heal.

### Resource Guardrails

- Every resource enables a visible battlefield or kingdom action
- No resource exists only as an abstract score
- Production updates when the peg is hit, not when the ball finishes
- Costs create composition choices rather than routine accumulation
- Telemetry must reveal consistently ignored or overproduced resources

## One-Lane Combat

Friendly and enemy units move, select targets, stop at attack range, attack, take damage, and die automatically. The castle loses health when enemies break through, and the run ends at zero castle health.

Combat is intentionally legible and creates changing production needs. It rewards preparation and turns resource shortages into urgent decisions. It is not a separate tactical game competing with pachinko for complexity.

## Friendly Units

The prototype contains four one-click deployments:

### Militia

A cheap frontline body that primarily consumes Food and Readiness.

### Swordsman

A stronger, more expensive general-purpose melee unit.

### Spearman

A Weapon-dependent anti-armor unit and the obvious counter to armored soldiers.

### Archer

Ranged support that must be protected by a frontline and performs well against fast or lightly armored groups.

The player chooses what to deploy but does not directly control individual units.

## Enemies and Waves

Core enemy roles are basic infantry, fast raiders, armored soldiers, siege threats, and ranged support. The first integrated implementation begins with Basic, Fast, and Armored enemies. Later waves recombine roles rather than constantly adding mechanics.

The prototype sequence tests:

1. Basic production and Militia deployment
2. Fast pressure and manual burst dropping
3. Weapon production and anti-armor counters
4. Mixed-army composition
5. Siege defense, structures, and abilities
6. Full-system mastery
7. Boss endurance and emergency response

Each wave needs a clear purpose, advance telegraphing, and enough time to prepare. Intermissions initially last 12 seconds.

## Defensive Structures

The battlefield has two fixed structure slots.

### Barricade

Delays enemies and protects the castle or friendly formation. It can be repaired or replaced.

### Archer Tower

Provides automatic ranged support for a meaningful Gold and Construction cost. It must support unit deployment rather than replace it.

Fixed slots preserve readability and prevent construction from becoming a second full strategy game.

## Kingdom Projects

The player pursues one project at a time. Workshop production advances it, and completion must visibly change the current run.

Prototype projects:

- Wall Reinforcement: improves castle defense or repair
- Archer Tower: unlocks ranged defense
- Blacksmith Upgrade: improves Weapon production or Weapon-dependent units

Projects express the survival-versus-growth tension and must pay off soon enough to matter during the run.

## Active Abilities

### Arrow Rain

Strong against enemy clusters, but not a solution to durable single targets.

### Heal

Preserves an expensive frontline and rewards good timing.

Abilities are powered by Ability Charge. They solve emergencies but cannot carry a run without continued machine production.

## Progression Within a Run

Machine use and wave completion grant XP. Level-up choices briefly slow the battle and offer a small set of upgrades:

- Improve or add a productive peg
- Increase ball capacity
- Improve regeneration
- Add a rare production bonus
- Unlock an experimental Heavy Ball
- Adopt a broad production identity

Example major choices:

- War Economy: stronger Barracks and Blacksmith production at a Food cost
- Fortified Kingdom: stronger Construction with higher deployment costs
- Rapid Logistics: faster ball regeneration

Upgrades should change priorities or rhythm, not only add invisible percentages. Meta progression, permanent research, and long-term unlock trees are outside the prototype.

## Boss

The prototype boss is an Ogre that advances slowly, has high health, deals heavy damage, periodically stuns friendly melee units, and summons basic enemies at health thresholds.

Before the boss, time slows, the threat is explained, the magazine refills, the player receives one peg-management action, and the player chooses a temporary blessing.

The boss tests production, deployment, frontline maintenance, and ability timing rather than introducing an unrelated puzzle.

## Prototype Run Shape

The target run lasts 10 to 12 minutes.

| System | Initial Value |
|---|---:|
| Normal waves | 6 |
| Boss waves | 1 |
| Intermission | 12 seconds |
| Ball capacity | 5 |
| Ball regeneration | 2.5 seconds |
| Auto-drop cadence | 3.5 seconds |
| Manual drop lockout | 0.25 seconds |
| Peg rows | 8 |
| Productive pegs | 24 |
| Neutral pegs | 12 |
| Average contacts per ball | 7 |
| Castle health | 100 |

These values are playtest starting points, not final balance promises. The player should rarely go longer than three seconds without visible cause-and-effect feedback.

## Prototype Definition of Done

A new tester can, without developer explanation:

1. Move the launcher and drop balls
2. Understand that building pegs produce resources
3. Change aim based on a battlefield need
4. Deploy units using those resources
5. Watch units fight automatically in one lane
6. Use auto-drop and manual burst dropping
7. Build or repair a defensive structure
8. Cast an active ability
9. Make a meaningful peg-layout decision
10. Survive or lose a six-wave run and boss

Visuals may remain graybox, but cause and effect cannot.

## Prototype Milestones

Development proceeds in this order:

1. Shared-screen scene and run controller
2. Pachinko magazine, regeneration, manual drop, and auto-drop
3. Typed building pegs and immediate resource feedback
4. One-lane automatic combat
5. Resource costs and unit deployment
6. Waves, telegraphs, victory, failure, and restart
7. Peg management and one kingdom project
8. Fixed defensive structures
9. Active abilities
10. Boss, results, and telemetry
11. Readability and feel pass
12. External playtest

The first integrated playable is complete after deployment:

```text
Drop -> Produce -> Deploy -> Observe
```

Progression and polish must not delay testing that loop.

## Required Telemetry

Record total, manual, and automatic balls; hits by peg type; resources produced and unspent; units deployed; structures built; abilities cast; castle health; run duration; completed projects; chosen upgrades; most-hit peg; and largest resource shortage.

Telemetry diagnoses the economy and attention loop. It is not an engagement-maximization system.

## Playtest Hypotheses

### Production Clarity

After two minutes, players can explain which peg types create which battlefield options.

### Manual and Automatic Drop Coexistence

Players use auto-drop during stable periods and manual bursts under pressure.

### Deployment Adds Agency

Selecting units feels tactical without excessive micromanagement.

### Growth Versus Survival Is Meaningful

Players sometimes regret overinvesting in construction and sometimes regret ignoring it.

### Peg Layout Matters

Players can identify at least one board change they would make before another run.

The concept is ready to expand only when most testers use both dropping modes, aim based on battlefield needs, and recall a meaningful growth-versus-survival choice.

## Content Lock

Do not add these before the first external playtest:

- More resource types
- Additional combat lanes
- More than four friendly units
- More than three core normal-enemy types
- Multiple kingdoms or board archetypes
- Shops, heroes, or equipment inventory
- Free-form defensive placement
- Procedural waves
- Meta progression, permanent research, or story systems
- More ball types beyond one experimental Heavy Ball

New content cannot solve a weak core loop.

## Product Guardrails

- Pachinko remains the primary interaction
- The machine and battlefield remain visible together
- Every productive hit has an immediate, readable consequence
- Battlefield pressure influences where the player aims
- Physics variation preserves learnable player intent
- Auto-drop prevents downtime but remains weaker than attentive manual play
- Deployment adds decisions without becoming unit micromanagement
- Combat creates demand rather than competing for complexity
- Construction creates a real survival-versus-growth tradeoff
- Structures support units rather than replacing them
- Abilities solve emergencies rather than carrying the run
- Board changes noticeably affect production
- Values remain data-driven and easy to tune
- The prototype stays narrow until the core loop is demonstrably fun

## Explicitly Removed from the Previous Concept

The following systems are no longer part of the core direction:

- Cards and deck construction
- Generated battle decks
- Unit or ability balls that resolve into battle content
- Aspect recipes and ordered transformation sequences
- Recipe-authored unit identities
- Separate machine and combat phases
- Three independent combat lanes

Existing data or code for these systems is legacy prototype material until migrated or removed.

## Vision Statement

Pachinko Kingdom combines the physical satisfaction of pachinko with the pressure and planning of real-time kingdom defense.

The machine is the economy.

The battlefield is the demand.

The player's aim connects them.