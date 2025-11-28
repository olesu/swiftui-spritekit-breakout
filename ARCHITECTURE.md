# Breakout Architecture Overview

## Core Principle

**Pure, stateless game logic with immutable state transformations.**

The architecture uses functional domain-driven design with pure functions, enabling fast, deterministic tests while maintaining clear separation between game logic, state management, and UI.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│          Application Layer              │  Entry point, dependency wiring
├─────────────────────────────────────────┤
│         Presentation Layer              │  SwiftUI views, @Observable models
│  ┌──────────────┐    ┌──────────────┐  │
│  │   IdleView   │    │   GameView   │  │
│  │ IdleViewModel│    │ GameViewModel│  │
│  └──────────────┘    └──────┬───────┘  │
│                              │          │
├─────────────────────────────┼──────────┤
│          SpriteKit Layer    │          │  Physics, rendering, user input
│         ┌──────────────┐    │          │
│         │  GameScene   │────┘          │
│         │  (SKScene)   │               │
│         └──────┬───────┘               │
│                │ GameEvent             │
├────────────────┼───────────────────────┤
│                ▼                        │
│          Domain Layer                  │  Pure game logic (stateless)
│    ┌──────────────────────┐            │
│    │  GameService         │            │
│    │  (Pure Functions)    │            │
│    └──────────────────────┘            │
│    ┌──────────────────────┐            │
│    │  GameState           │            │
│    │  (Aggregate Root)    │            │
│    └──────────────────────┘            │
├─────────────────────────────────────────┤
│      Infrastructure Layer               │  Persistence, adapters
│  ┌────────────────────────────┐         │
│  │ GameStateRepository        │         │
│  │ InMemoryGameStateRepository│         │
│  └────────────────────────────┘         │
│  JsonBrickLayoutAdapter                 │
│  JsonGameConfigurationAdapter           │
└─────────────────────────────────────────┘
```

## Stateless Architecture

**Flow:** Event → Load State → Transform State → Save State → Update UI

```swift
// 1. Event received from SpriteKit
func handleGameEvent(_ event: GameEvent) {
    processEvent(event)      // Transform state via service
    updateScore()            // Notify UI
    updateLives()
    checkBallReset()
    checkGameEnd()
}

// 2. Pure function processes event
func processEvent(_ event: GameEvent) {
    let state = service.processEvent(event, state: currentState)
    repository.save(state)
}

// 3. Service uses pure functions
func processEvent(_ event: GameEvent, state: GameState) -> GameState {
    guard state.status == .playing else { return state }

    switch event {
    case .brickHit(let brickID):
        guard let brick = state.bricks[brickID] else { return state }
        var updatedBricks = state.bricks
        updatedBricks.removeValue(forKey: brickID)
        let newScore = state.score + brick.color.pointValue
        let newStatus = updatedBricks.isEmpty ? .won : state.status
        return state
            .with(bricks: updatedBricks)
            .with(score: newScore)
            .with(status: newStatus)
    case .ballLost:
        let newLives = state.lives - 1
        let newStatus = newLives <= 0 ? .gameOver : state.status
        let ballResetNeeded = newLives > 0
        return state
            .with(lives: newLives)
            .with(status: newStatus)
            .with(ballResetNeeded: ballResetNeeded)
    }
}
```

## Key Design Patterns

### 1. Domain-Driven Design (DDD)

**Aggregate Root:** `GameState` owns all game state
```swift
struct GameState: Equatable {
    let score: Int
    let lives: Int
    let status: GameStatus
    let bricks: [BrickId: Brick]
    let ballResetNeeded: Bool

    // Immutable updates via copy-on-write
    func with(score: Int) -> GameState { ... }
    func with(lives: Int) -> GameState { ... }
}
```

**Value Objects:** `BrickId`, `Brick`, `BrickColor`

**Domain Service:** `GameService` provides stateless operations
```swift
protocol GameService {
    func startGame(state: GameState) -> GameState
    func processEvent(_ event: GameEvent, state: GameState) -> GameState
    func acknowledgeBallReset(state: GameState) -> GameState
}
```

### 2. Repository Pattern

State persistence abstracted behind repository:
```swift
protocol GameStateRepository {
    func load() -> GameState
    func save(_ state: GameState)
}
```

### 3. Pure Functions

All domain logic is pure functions `(event, state) → state`:
- **Deterministic:** Same input → same output
- **No side effects:** Only transforms data
- **Easily testable:** No mocking required
- **Composable:** Functions combine predictably

### 4. Immutable State

State never mutated, always copied with modifications:
```swift
// Before (mutable):
scoreCard.score(points)
bricks.remove(withId: id)

// After (immutable):
state
    .with(score: state.score + points)
    .with(bricks: updatedBricks)
```

### 5. Dependency Injection

Dependencies passed explicitly via initializers:
```swift
GameViewModel(
    service: BreakoutGameService(),
    repository: InMemoryGameStateRepository(),
    configurationService: configService,
    screenNavigationService: navService,
    gameResultService: resultService
)
```

## Directory Structure

```
Breakout/
├── Application.swift              # Entry point, dependency wiring
├── Domain/                        # Pure game logic (stateless)
│   ├── GameService.swift          # Service protocol
│   ├── BreakoutGameService.swift  # Stateless implementation
│   ├── GameState.swift            # Aggregate root
│   ├── GameStatus.swift           # State machine enum
│   ├── GameStateRepository.swift  # Repository protocol
│   ├── Bricks.swift               # BrickId, Brick, BrickColor
│   ├── GameEvent.swift            # Events from SpriteKit
│   └── BrickLayoutConfig.swift    # JSON-based layouts
├── Infrastructure/                # Persistence implementations
│   └── InMemoryGameStateRepository.swift
├── Game/                          # Main game screen
│   ├── GameView.swift             # SwiftUI view
│   ├── GameViewModel.swift        # Coordinates domain + scene
│   └── GameScene.swift            # SpriteKit scene (physics)
├── Idle/                          # Idle screen (start game)
│   ├── IdleView.swift
│   └── IdleViewModel.swift
├── GameEnd/                       # Game end screen
│   ├── GameEndView.swift
│   └── GameEndViewModel.swift
├── Navigation/
│   └── NavigationCoordinator.swift  # State-based routing
├── Nodes/                         # SpriteKit sprites + physics
│   ├── BallSprite.swift, PaddleSprite.swift, BrickSprite.swift
│   ├── PhysicsBodyConfigurers.swift
│   ├── BrickNodeManager.swift
│   ├── ScoreLabel.swift, LivesLabel.swift
│   └── SpriteKitNodeCreator.swift
├── Physics/                       # Extracted physics logic
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

Enforced by pure functions. Events only processed in `.playing` state.

### State Lifecycle
```
1. Repository.load() → GameState
2. Service.processEvent(event, state) → GameState
3. Repository.save(state)
4. UI callbacks triggered from new state
```

### SwiftUI + SpriteKit Bridge

`GameViewModel` coordinates two update mechanisms:
- **@Observable properties** → SwiftUI (declarative)
- **Closure callbacks** → GameScene (imperative)

```swift
// After state change, update both
private func updateScore() {
    onScoreChanged?(currentState.score)  // → SpriteKit label
}
// currentScore property automatically updates SwiftUI via @Observable
```

## Event-Driven Flow

**Complete event flow with ball reset:**

```
1. Ball hits gutter (SpriteKit)
   ↓
2. GameScene.didBegin(contact)
   ↓
3. onGameEvent(.ballLost)
   ↓
4. GameViewModel.handleGameEvent(.ballLost)
   ↓
5. GameService.processEvent(.ballLost, state) → newState
   - lives decreased
   - ballResetNeeded = true
   - status = .gameOver (if lives ≤ 0)
   ↓
6. Repository.save(newState)
   ↓
7. Callbacks triggered:
   - updateLives() → GameScene updates lives label
   - checkBallReset() → onBallResetNeeded?()
   - checkGameEnd() → navigate to game end screen
   ↓
8. GameScene.resetBall()
   - Animates ball reset
   - Calls onBallResetComplete?()
   ↓
9. GameViewModel.acknowledgeBallReset()
   ↓
10. GameService.acknowledgeBallReset(state) → newState
    - ballResetNeeded = false
    ↓
11. Repository.save(newState)
```

## Testing Strategy

**62 passing tests** with focus on pure function testing:

### Domain Tests (Fast, Pure Functions)
- `GameServiceTest` - Stateless game logic (18 tests)
  - State transitions
  - Score calculations
  - Win/lose conditions
  - Ball reset logic
- `GameStateTest` - Aggregate root (6 tests)
  - Immutable updates
  - Initial state
- `GameStateRepositoryTest` - Persistence (3 tests)

### ViewModel Tests (Integration)
- `GameViewModelTest` - Coordination logic (13 tests)
  - Event processing
  - State persistence
  - UI callbacks
  - Navigation

### Physics Tests (Isolated Logic)
- `PaddleBounceCalculatorTest` - Pure calculation
- `PaddleBounceApplierTest` - Full integration
- `BallResetConfiguratorTest` - Reset configuration

### Integration Tests
- `GameSceneTest` - Scene behavior
- `SpriteKitNodeCreatorTest` - Node creation with DI

### Adapter Tests
- `JsonBrickLayoutAdapterTest`
- `GameConfigurationServiceTest`

## Configuration

### Data-Driven Design
Brick layouts defined in JSON:
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

1. **Pure Function Benefits**
   - Predictable and deterministic
   - Easy to test (no mocking)
   - No hidden dependencies
   - Trivial to reason about

2. **Fast Tests**
   - Domain tests run instantly
   - No async, no frameworks
   - 100% reproducible

3. **Type Safety**
   - Compiler enforces state transitions
   - Immutable data prevents bugs
   - Equatable enables time-travel debugging

4. **Clear Boundaries**
   - Service: pure logic
   - Repository: persistence
   - ViewModel: coordination
   - Scene: physics/rendering

5. **Maintainable**
   - Changes localized to single functions
   - No global state
   - Explicit dependencies

6. **Scalable**
   - Easy to add new events
   - Easy to add new game states
   - Easy to add new side effects

## Migration Notes

The codebase was successfully migrated from a stateful object-oriented architecture to this pure functional architecture in 7 phases:

1. Created `GameState` aggregate root
2. Implemented stateless `GameService`
3. Created `GameStateRepository`
4. Updated `GameViewModel` to use new architecture
5. Integrated with `GameView`
6. Removed old engine code (-467 lines)
7. Manual testing and bug fixes

**Result:** 1,102 lines of code deleted, architecture simplified, all tests passing.

## Influences

- Domain-Driven Design (Evans)
- Functional Core, Imperative Shell (Boundaries - Gary Bernhardt)
- Pure Functions & Immutability (Functional Programming)
- Repository Pattern (Fowler)
- Event Sourcing concepts (state as fold over events)
