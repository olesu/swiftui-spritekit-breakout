# Breakout Game - Event-Driven Domain Logic TDD Checklist

## Architecture: SpriteKit Handles Physics, Domain Handles Game Rules

**Core Insight**: Let SpriteKit do what it does best (physics, collision detection, rendering) while keeping domain logic focused on pure game rules and state management.

## Domain Responsibilities 🎯
- React to events from SpriteKit layer
- Track game state (score, lives, brick status)
- Enforce game rules (scoring, win/lose conditions)
- Manage game progression

## SpriteKit Responsibilities 🎮  
- Physics simulation and collision detection
- Visual rendering and animations
- User input handling
- Send events to domain when collisions occur

---

## Core Domain Concepts

### 1. Game Events 📨
**Messages sent from SpriteKit to domain when things happen**

- [x] `GameEvent` enum with cases:
  - [x] `.brickHit(brickID: UUID)`
  - [x] `.ballLost`
  - [ ] `.gameStarted`
  - [ ] `.gamePaused`
  - [ ] `.gameResumed`
- [x] Event processing pipeline in domain (BreakoutGameEngine implemented)
- [x] Event validation (ignore events in wrong game state)

### 2. Game State Management 🎮
**Current state of the game session**

- [x] `GameStatus` enum: `.idle`, `.playing`, `.won`, `.gameOver` (complete - missing `.paused`)
- [x] Game state tracking (BreakoutGameEngine tracks status, score, lives, active bricks)
- [x] State transition rules (.playing -> .won/.gameOver transitions working)
- [ ] Game initialization and reset logic

### 3. Brick Management 🧱
**Tracking which bricks exist and their properties**

- [x] `Brick` struct with ID and color
- [x] `Bricks` registry to track all bricks in current level
- [x] Brick type/color to point value mapping (BrickColor enum with pointValue)
- [x] Brick destruction logic (remove from active set)
- [x] Query methods (all bricks destroyed? how many remain?)

### 4. Scoring System 🏆
**Rules for calculating and tracking score**

- [x] Point values for different brick colors:
  - Red: 7 points
  - Orange: 7 points
  - Yellow: 4 points
  - Green: 1 point
- [x] Score calculation based on brick color (ScoreCard + BrickColor.pointValue)
- [ ] Bonus scoring rules (if any)
- [ ] High score tracking (optional)

### 5. Lives & Game Progression ❤️
**Managing player lives and win/lose conditions**

- [x] Lives management (LivesCard implemented)
- [x] Ball loss handling (decrement lives)
- [x] Game over detection (lives = 0)
- [x] Win condition detection (no bricks remaining via Bricks.someRemaining)
- [ ] Level progression (optional for MVP)

### 6. Game Engine Coordination 🎯
**The main coordinator that processes events and updates state**

- [x] `BreakoutGameEngine` class
- [x] Process incoming events from SpriteKit (.brickHit, .ballLost)
- [x] Update game state based on events (score, lives, win/gameOver)
- [x] Return state changes/commands back to SpriteKit (via query methods)
- [x] Event validation (ignore events when not in .playing state)
- [x] Comprehensive test coverage (15 passing tests including integration test)
- [x] Game initialization in .idle state with start() method
- [ ] Thread safety considerations (deferred)

---

## ✅ MVP Domain Model Complete!

The domain layer is production-ready with:
- 15 passing tests covering all core functionality
- Clean separation from SpriteKit
- Proper state management (.idle → .playing → .won/.gameOver)
- Color-based scoring system
- Edge case handling

**Ready for SpriteKit integration!**

---

## TDD Implementation Order

### Phase 1: Core State & Events
Simple, pure domain logic:
1. `GameEvent` enum and basic validation
2. `GameState` struct and initialization
3. `GameStatus` transitions and rules

### Phase 2: Brick System
Brick tracking and management:
1. `BrickInfo` and `BrickRegistry`
2. Brick destruction logic
3. Win condition checking (no bricks left)

### Phase 3: Scoring & Lives
Game progression mechanics:
1. Score calculation per brick type
2. Lives management and ball loss
3. Game over detection

### Phase 4: Game Engine
Orchestrating everything:
1. `BreakoutGameEngine` event processing
2. State update pipeline
3. Integration with existing architecture

---

## Example Domain API Design

```swift
// Clean event-driven interface
enum GameEvent {
    case brickHit(brickID: UUID)
    case ballLost
    case gameStarted
}

// Simple state management
struct GameState {
    let status: GameStatus
    let score: Int
    let lives: Int
    let activeBricks: Set<UUID>
    
    var isGameOver: Bool { lives <= 0 }
    var isWon: Bool { activeBricks.isEmpty }
}

// Focused game engine
class BreakoutGameEngine {
    private var currentState: GameState
    
    func process(event: GameEvent) -> GameState {
        // Pure function: event + old state -> new state
    }
    
    func initializeGame(brickIDs: Set<UUID>) -> GameState {
        // Set up initial game state
    }
}
```

## Integration with SpriteKit ✅ IMPLEMENTED

The integration between SpriteKit and the domain layer is complete:

```swift
// GameScene detects collisions and sends events to GameViewModel
class GameScene: SKScene, SKPhysicsContactDelegate {
    private let onGameEvent: (GameEvent) -> Void
    private var brickNodeManager: BrickNodeManager?

    func didBegin(_ contact: SKPhysicsContact) {
        // Ball + Brick collision
        if contactMask == (CollisionCategory.ball.mask | CollisionCategory.brick.mask) {
            if let brickId = extractBrickID(from: contact) {
                onGameEvent(.brickHit(brickID: brickId))
                removeBrick(id: brickId)  // Delegates to BrickNodeManager
            }
        }

        // Ball + Gutter collision
        if contactMask == (CollisionCategory.ball.mask | CollisionCategory.gutter.mask) {
            onGameEvent(.ballLost)
        }
    }
}

// GameViewModel coordinates between scene and engine
class GameViewModel {
    private var engine: GameEngine?
    var onScoreChanged: ((Int) -> Void)?
    var onLivesChanged: ((Int) -> Void)?

    func handleGameEvent(_ event: GameEvent) {
        engine?.process(event: event)

        // Notify scene of state changes via closures
        if let engine = engine {
            onScoreChanged?(engine.currentScore)
            onLivesChanged?(engine.remainingLives)
        }
    }
}

// BrickNodeManager handles brick node removal in isolation
class BrickNodeManager {
    func remove(brickId: UUID) {
        // Removes brick sprite from scene
    }
}
```

## Key TDD Benefits ✅ ACHIEVED
- **Focused domain**: Only game rules, no physics complexity
- **Event-driven**: Clear input/output for tests
- **Fast tests**: No SpriteKit dependencies in domain tests
- **Clear separation**: Graphics vs logic concerns separated
  - `BrickNodeManager`: Isolated brick node management (testable without SKView)
  - `BreakoutGameEngine`: Pure game logic (no SpriteKit dependencies)
  - `GameScene`: Only handles SpriteKit physics and rendering
  - `GameViewModel`: Coordinates between scene and engine via closures
- **Easy to reason about**: Event processing and state updates via callbacks

## Code Cleanup & Refactoring History

### Recent Refactorings (2025-01)
- [x] Removed unused production code (AutoPaddle, LevelLoaderService, Level, BrickType)
- [x] Removed test-only production APIs from GameEngine protocol
- [x] Removed weak tests that checked implementation details
- [x] Extracted BrickNodeManager for isolated brick removal testing
- [x] Simplified GameScene to delegate brick management

### Scoring System
- [x] Fixed: All bricks were scoring 1 point regardless of color
  - Issue: `onBrickAdded` callback only passed brick ID, not color
  - Solution: Updated callback to pass both ID and NSColor, added BrickColor.init(from: NSColor)
  - Now correctly awards: Red=7, Orange=7, Yellow=4, Green=1 points

### Communication Architecture
- [x] Migrated from NotificationCenter to closure-based callbacks
  - GameViewModel uses `onScoreChanged` and `onLivesChanged` closures
  - GameScene sets up callbacks in `setupViewModelCallbacks()`
  - Cleaner, more testable architecture

## Known Issues & Future Improvements

### Recent Improvements (2025-01-15)
Three critical architecture issues have been fixed:
- ✅ **GameScene Recreation Bug**: Fixed critical performance issue where scene was recreated on every SwiftUI render
- ✅ **Configuration Caching**: Eliminated repeated service calls by caching configuration values
- ✅ **@Observable Pattern**: Properly implemented SwiftUI observation with exposed properties

All tests continue to pass after these refactorings.

### Architecture & Modularity (High Priority)

#### GameView.swift - GameScene Recreation Bug ✅ FIXED
- [x] **CRITICAL**: GameScene recreated on every SwiftUI render (GameView.swift:26-34)
  - Problem: Scene created in view body, causing recreation on any SwiftUI update
  - Impact: Performance degradation, game state loss, memory leaks
  - Solution: Moved scene creation to @State, created once in onAppear
  - Files affected: GameView.swift
  - Commit: 6135bcc

#### GameConfigurationModel - Performance Issue ✅ FIXED
- [x] Cache GameConfiguration instead of calling service repeatedly (GameModel.swift:6-31)
  - Problem: Every computed property calls `getGameConfiguration()` which may be expensive
  - Impact: Unnecessary repeated computation
  - Solution: Cache configuration and scale in init, use cached values
  - Files affected: GameModel.swift
  - Commit: 501ed5a

#### GameViewModel - SwiftUI Pattern Violations ✅ FIXED
- [x] Fix @Observable usage - expose properties instead of callbacks (GameViewModel.swift:5, 12-13)
  - Problem: Mixing @Observable with manual callbacks (onScoreChanged, onLivesChanged)
  - Impact: Confusing observation mechanism, not idiomatic SwiftUI
  - Solution: Exposed currentScore/remainingLives as @Observable properties
  - Files affected: GameViewModel.swift
  - Commit: 09614b5
  - Note: Callbacks retained for GameScene (non-SwiftUI) communication

#### GameViewModel - Tight Coupling to SpriteKit
- [ ] Remove SpriteKit dependencies from ViewModel (GameViewModel.swift:41-52)
  - Problem: Returns `[NodeNames: SKNode]` - ViewModel knows about SpriteKit
  - Impact: Violates separation of concerns, hard to test
  - Solution: Extract to SceneConfigurator/Factory, pass domain models
  - Files affected: GameViewModel.swift, GameView.swift
  - Note: Larger refactoring, deferred to future iteration

### Architecture & Modularity (Medium Priority)

#### Inconsistent ViewModel Pattern
- [ ] Standardize ViewModel pattern across app
  - Problem: GameViewModel is @Observable class, IdleViewModel is struct wrapper
  - Impact: Architectural confusion, inconsistent patterns
  - Solution: Make both @Observable classes OR both struct wrappers
  - Files affected: GameViewModel.swift, IdleViewModel.swift

#### NotificationCenter in SwiftUI
- [ ] Replace NotificationCenter with direct callbacks/bindings (GameView.swift:36-45)
  - Problem: Using NotificationCenter for paddle control is outdated
  - Impact: Loose coupling, no type safety, hard to trace
  - Solution: Pass callback/binding to ViewModel directly
  - Files affected: GameView.swift, GameScene.swift, NotificationNames.swift

#### Circular Dependencies
- [ ] Remove circular dependency between GameView/GameScene/GameViewModel
  - Problem: GameScene has both onGameEvent callback AND viewModel reference
  - Impact: Bidirectional dependency is a code smell
  - Solution: Communicate only through callbacks, remove viewModel param
  - Files affected: GameView.swift, GameScene.swift

#### GameScene - Too Many Responsibilities
- [ ] Extract UserDefaults monitoring from GameScene (GameScene.swift:151-176)
  - Problem: GameScene handles physics, paddle, UI updates, UserDefaults, bricks
  - Impact: Violates Single Responsibility Principle
  - Solution: Extract to separate controllers/managers
  - Files affected: GameScene.swift

#### Application.swift - Direct State Management
- [ ] Create NavigationCoordinator for state-based routing (Application.swift:33-44)
  - Problem: App directly switches on storage.state, bypasses service layer
  - Impact: Tight coupling, hard to test routing logic
  - Solution: Use GameStateService consistently, create coordinator
  - Files affected: Application.swift

### Architecture & Modularity (Low Priority)

#### Force Unwrapping in Service
- [ ] Add error handling in GameConfigurationService (GameConfigurationService.swift:16)
  - Problem: `try!` will crash on config loading failure
  - Solution: Provide fallback or propagate error properly
  - Files affected: GameConfigurationService.swift

#### Duplicated GameState Enum
- [ ] Rename engine's GameState to avoid confusion with service's GameState
  - Problem: Two enums with same name in different contexts
  - Solution: Rename to EngineState or consolidate if same concept
  - Files affected: BreakoutGameEngine.swift, GameStateService.swift

#### Storage Abstraction
- [ ] Move InMemoryStorage to own file, use via service layer
  - Problem: Defined in Application.swift, accessed directly
  - Solution: Move to own file, access through GameStateService
  - Files affected: Application.swift

### Physics & Gameplay
- [ ] Prevent ball from moving in 90-degree trajectory (straight up) from paddle
  - When ball hits paddle at certain angles, it can bounce straight up and get stuck
  - Need to adjust ball velocity after paddle collision to ensure minimum horizontal component
- [ ] Ball respawn logic after ballLost event
  - Currently, ball needs to be manually respawned
  - Should reset ball to paddle position automatically

## Current Test Coverage

**12 passing tests:**
- Domain/BreakoutGameEngineTest (5 tests)
- Domain/BricksTest
- Domain/ScoreCardTest
- Domain/LivesCardTest
- Domain/GameEventTest
- Game/GameViewModelTest (3 tests)
- Nodes/BrickNodeManagerTest (1 test)
- ConfigurationModelTest
- And others...

**Architecture Benefits:**
- No SpriteKit dependencies in domain tests
- Fast, focused unit tests
- Clear separation of concerns