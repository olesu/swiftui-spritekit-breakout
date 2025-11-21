# Breakout Architecture Overview

## Core Principle

**SpriteKit handles physics, Domain handles game rules.**

The architecture strictly separates physics simulation from game logic, enabling fast, framework-independent domain tests while leveraging SpriteKit's strengths.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│          Application Layer              │  Entry point, dependency wiring
├─────────────────────────────────────────┤
│         Presentation Layer              │  SwiftUI views, @Observable models
│  ┌──────────────┐    ┌──────────────┐  │
│  │   IdleView   │    │   GameView   │  │
│  │ IdleViewModel│    │ GameViewModel│  │
│  └──────────────┘    └──────────────┘  │
├─────────────────────────────────────────┤
│          SpriteKit Layer                │  Physics, rendering, user input
│         ┌──────────────┐                │
│         │  GameScene   │                │
│         │  (SKScene)   │                │
│         └──────┬───────┘                │
│                │ GameEvent              │
├────────────────┼─────────────────────────┤
│                ▼                         │
│          Domain Layer                   │  Pure game logic (no frameworks)
│    ┌──────────────────────┐             │
│    │ BreakoutGameEngine   │             │
│    │   (GameEngine)       │             │
│    └──────────────────────┘             │
│      Score, Lives, Bricks, State        │
├─────────────────────────────────────────┤
│          Adapter Layer                  │  External I/O (JSON, storage)
│  JsonBrickLayoutAdapter                 │
│  JsonGameConfigurationAdapter           │
│  InMemoryGameStateAdapter               │
└─────────────────────────────────────────┘
```

## Event-Driven Communication

**Flow:** SpriteKit collision → GameEvent → Domain processing → State update → UI callback

```swift
// SpriteKit detects collision
func didBegin(_ contact: SKPhysicsContact) {
    if contactMask == (ball | brick) {
        onGameEvent(.brickHit(brickID: id))  // Send to domain
    }
}

// Domain processes event
func process(event: GameEvent) {
    switch event {
    case .brickHit(let id):
        bricks.remove(withId: id)           // Update state
        scoreCard.score(brick.color.pointValue)
        if !bricks.someRemaining { gameState = .won }
    }
}

// Callbacks notify UI layers
onScoreChanged?(engine.currentScore)         // For SpriteKit labels
onLivesChanged?(engine.remainingLives)       // For SpriteKit labels
self.currentScore = engine.currentScore      // For SwiftUI @Observable
```

## Key Design Patterns

### 1. Protocol-Oriented Design
All major abstractions use protocols for dependency injection:
- `GameEngine` - Core game logic abstraction
- `GameStateAdapter` - Storage abstraction
- `BrickLayoutAdapter` - Layout loading abstraction
- `NodeCreator` - SpriteKit node creation abstraction

### 2. Adapter Pattern
External dependencies isolated behind adapters:
- `JsonBrickLayoutAdapter` - Loads brick layouts from JSON
- `JsonGameConfigurationAdapter` - Loads game config from JSON
- `InMemoryGameStateAdapter` - In-memory state storage

### 3. Value vs Reference Types
- **Value types (struct):** Domain models (Brick, BrickId, ScoreCard, LivesCard)
- **Reference types (class):** Stateful components (GameEngine, GameViewModel, GameScene)

### 4. Dependency Injection
No hidden dependencies. All dependencies passed via initializers:
```swift
GameViewModel(configurationModel: config, engineFactory: factory)
GameScene(size: size, nodes: nodes, onGameEvent: handler)
BreakoutGameEngine(bricks: bricks, lives: 3)
```

### 5. Extracted Testable Components
Complex operations extracted to dedicated, testable types:
- `PaddleBounceCalculator` - Pure bounce angle calculation
- `PaddleBounceApplier` - Full paddle bounce integration
- `BallResetConfigurator` - Ball reset configuration
- `BrickNodeManager` - Isolated brick node management

## Directory Structure

```
Breakout/
├── Application.swift              # Entry point, dependency wiring
├── Domain/                        # Pure game logic (framework-free)
│   ├── BreakoutGameEngine.swift
│   ├── Bricks.swift              # Brick registry
│   ├── ScoreCard.swift, LivesCard.swift
│   ├── GameEvent.swift           # Events from SpriteKit
│   ├── GameStateService.swift
│   ├── BrickLayoutConfig.swift   # JSON-based layouts
│   └── Adapters/                 # External I/O abstractions
│       ├── JsonBrickLayoutAdapter.swift
│       ├── JsonGameConfigurationAdapter.swift
│       └── InMemoryGameStateAdapter.swift
├── Game/                         # Main game screen
│   ├── GameView.swift           # SwiftUI view
│   ├── GameViewModel.swift      # Coordinates domain + scene
│   └── GameScene.swift          # SpriteKit scene (physics)
├── Idle/                         # Idle screen (start game)
│   ├── IdleView.swift
│   └── IdleViewModel.swift
├── Navigation/
│   └── NavigationCoordinator.swift  # State-based routing
├── Nodes/                        # SpriteKit sprites + physics
│   ├── BallSprite.swift, PaddleSprite.swift, BrickSprite.swift
│   ├── PhysicsBodyConfigurers.swift
│   ├── BrickNodeManager.swift
│   └── SpriteKitNodeCreator.swift
├── Physics/                      # Extracted physics logic
│   ├── PaddleBounceCalculator.swift
│   ├── PaddleBounceApplier.swift
│   └── BallResetConfigurator.swift
└── Resources/
    └── 001-classic-breakout.json  # Data-driven brick layout
```

## State Management

### Game State Machine
```
.idle → .playing → (.won | .gameOver)
```

Domain enforces transitions. Only processes events in `.playing` state.

### SwiftUI + SpriteKit Bridge
`GameViewModel` bridges two update mechanisms:
- **@Observable properties** → SwiftUI views (declarative)
- **Closure callbacks** → GameScene (imperative)

Both updated synchronously to maintain consistency.

## Testing Strategy

**35+ passing tests** with clear separation:

### Domain Tests (Fast, No SpriteKit)
- `BreakoutGameEngineTest` - Core game logic
- `BricksTest`, `ScoreCardTest`, `LivesCardTest` - Domain models
- `GameEventTest` - Event validation

### Physics Tests (Isolated Logic)
- `PaddleBounceCalculatorTest` - Pure calculation
- `PaddleBounceApplierTest` - Full integration
- `BallResetConfiguratorTest` - Reset configuration

### Integration Tests
- `GameViewModelTest` - View model coordination
- `GameSceneTest` - Scene behavior
- `SpriteKitNodeCreatorTest` - Node creation with DI

## Configuration

### Data-Driven Design
Brick layouts defined in JSON, not hardcoded:
```json
{
  "levelName": "Classic Breakout",
  "mapCols": 14, "mapRows": 8,
  "brickTypes": [
    {"id": 1, "colorName": "Green", "scoreValue": 1},
    {"id": 2, "colorName": "Yellow", "scoreValue": 4}
  ],
  "layout": [1, 1, 2, 2, ...]
}
```

### Error Handling
Resilient fallback pattern:
- Configuration fails → use fallback defaults
- Layout fails → empty layout (no crash)
- All errors logged via `os_log`

## Key Architectural Benefits

1. **Fast Tests** - Domain tests run instantly (no SpriteKit initialization)
2. **Framework Independence** - Domain has zero UI dependencies
3. **Clear Boundaries** - Protocols define layer contracts
4. **Easy to Reason About** - Event flow is explicit and unidirectional
5. **Testable Components** - Complex logic extracted to dedicated types
6. **Data-Driven** - New levels via JSON, no code changes
7. **Type Safety** - Swift's type system prevents invalid states
8. **Maintainable** - Clear separation makes changes localized

## Influences

- Event-driven domain logic pattern
- Clean Architecture (layered separation of concerns)
- Hexagonal Architecture (Ports & Adapters for external dependencies)
