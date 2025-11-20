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

#### GameViewModel - Tight Coupling to SpriteKit ✅ FIXED
- [x] Remove SpriteKit dependencies from ViewModel
  - Problem: Returns `[NodeNames: SKNode]` - ViewModel knows about SpriteKit
  - Impact: Violates separation of concerns, hard to test
  - Solution: Move scene creation to GameView, ViewModel only handles domain models
  - Files affected: GameViewModel.swift, GameView.swift, GameScene.swift
  - Commits: ee0c2a2, 2da877c, 43bfc76, 4cc7a7d, 2e0677c, ed0dfb5

  **Implementation (TDD):**
  1. ✅ Add `initializeEngine(with: Bricks)` method to GameViewModel
  2. ✅ Update tests to use new method (removed obsolete tests)
  3. ✅ Move scene creation logic from ViewModel to GameView
  4. ✅ Remove `nodeCreator` property from GameViewModel
  5. ✅ Remove `createNodes()` method from GameViewModel
  6. ✅ Remove `import SpriteKit` from GameViewModel
  7. ✅ Remove `viewModel` parameter from GameScene (fixes circular dependency)
  8. ✅ GameScene already had direct `updateScore()`/`updateLives()` methods
  9. ✅ Update GameView to call scene methods via ViewModel callbacks

  **Result:**
  - GameViewModel: Only domain models, no SpriteKit ✅
  - GameView: Handles all SpriteKit scene setup ✅
  - GameScene: Receives updates via direct method calls ✅
  - Clear dependency flow: View → ViewModel → Domain ✅
  - No circular dependencies ✅

### Architecture & Modularity (High Priority)

#### Force Unwrapping in Service ⚠️ CRITICAL ✅ FIXED
- [x] Add error handling in GameConfigurationService (GameConfigurationService.swift:16)
  - Problem: `try!` will crash on config loading failure
  - Impact: App crash if configuration file is missing or malformed
  - Solution: Added do-catch with fallback configuration, replaced fatalError with throw
  - Files affected: GameConfigurationService.swift, JsonGameConfigurationLoader.swift
  - Commit: 368c6aa

#### SwiftUI State Management Issues ⚠️ HIGH ✅ FIXED
- [x] Fix @State/@Observable pattern inconsistencies (GameView.swift:15-16)
  - Problems:
    1. GameViewModel is @Observable but wrapped in @State (confusing)
    2. Strong capture of viewModel in closures (potential memory leak at lines 68-70)
  - Solution:
    - Removed @State wrapper from viewModel (now uses @Observable directly)
    - Changed [viewModel] to [weak viewModel] in onGameEvent closure
    - Note: @State for scene is acceptable - scene created once in lifecycle, managed by SpriteView
  - Files affected: GameView.swift
  - Commit: 92f8f8f

#### Debug Overlay Removal ✅ REMOVED
- [x] Remove debug overlay functionality from GameScene
  - Removed UserDefaults monitoring for showing/hiding brick area overlay
  - Removed files: DevSettingsView.swift, UserDefaultsMonitor.swift, UserDefaultsKeys.swift, Shapes.swift
  - Cleaned up GameScene.swift to remove overlay-related code
  - Settings menu in Application.swift removed

### Architecture & Modularity (Medium Priority)

#### Inconsistent ViewModel Pattern ✅ FIXED
- [x] Standardize ViewModel pattern across app
  - Problem: GameViewModel is @Observable class, IdleViewModel is struct wrapper around IdleModel
  - Impact: Architectural confusion, inconsistent patterns across codebase
  - Solution: Removed wrapper layer, renamed IdleModel → IdleViewModel for consistency
  - Files affected: IdleViewModel.swift (renamed from IdleModel.swift), IdleView.swift, IdleViewWrapper, Application.swift, IdleViewModelTest.swift
  - Commit: 116fa35

#### NotificationCenter Cleanup ✅ COMPLETE
- [x] Replaced NotificationCenter with direct callbacks for paddle control (GameView.swift)
  - Problem: Using NotificationCenter for paddle control is outdated
  - Solution: GameView now calls scene.movePaddle(to:) directly
  - Files affected: GameView.swift, GameScene.swift
- [x] Remove unused NotificationNames.paddlePositionChanged (NotificationNames.swift)
  - Problem: Dead code, entire file contained only unused notification
  - Solution: Deleted entire NotificationNames.swift file
  - Files affected: NotificationNames.swift (deleted)
  - Commit: 11dfed3

#### Application.swift - Direct State Management ✅ FIXED
- [x] Create NavigationCoordinator for state-based routing (Application.swift:33-44)
  - Problem: App directly switches on storage.state, bypasses GameStateService layer
  - Impact: Tight coupling, hard to test routing logic, inconsistent with architecture
  - Solution: Created NavigationCoordinator with computed property that observes storage state
  - Implementation:
    - Created NavigationCoordinator class with @Observable
    - Computes currentScreen from storage.state automatically
    - Application.swift now switches on navigationCoordinator.currentScreen
    - 6 tests added to verify all state → screen mappings
  - Files affected: NavigationCoordinator.swift (new), NavigationCoordinatorTest.swift (new), Application.swift
  - Commit: eceeeda

#### Missing Access Control ✅ FIXED
- [x] Add proper access control to domain models
  - Problems:
    - ScoreCard.scores is public mutable (should be private)
    - LivesCard.remaining is public mutable (should be private)
    - Bricks.bricks dictionary is exposed (should be private)
  - Impact: Breaks encapsulation, allows direct state mutation
  - Solution: Added private(set) and private modifiers, created proper APIs
  - Implementation:
    - ScoreCard.scores: Changed to `private(set)` (read-only from outside)
    - LivesCard.remaining: Changed to `private(set)` (read-only from outside)
    - Bricks.bricks: Changed to `private` (completely hidden)
    - Added Bricks.get(byId:) method for safe brick access
    - Updated BreakoutGameEngine to use new API
    - Fixed test to use public API instead of accessing internals
  - Files affected: ScoreCard.swift, LivesCard.swift, Bricks.swift, BreakoutGameEngine.swift, GameViewModelTest.swift
  - Commit: f74d724

#### Hardcoded Brick Layout → Data-Driven JSON Loading ✅ COMPLETE
- [x] Extract hardcoded brick layout to data-driven JSON configuration (BrickSprite.swift:23-168)
  - Problem: 112 hardcoded brick positions in ClassicBricksLayout class
  - Impact:
    - Violates Single Responsibility Principle
    - Hard to change brick patterns (requires modifying class)
    - Not reusable for different layouts
    - Cannot create new levels without code changes
  - Current State:
    - JSON file exists at Resources/001-classic-breakout.json but is unused
    - JSON uses grid-based layout (14 cols × 8 rows = 112 bricks)
    - Current hardcoded layout IS grid-based (x spacing: 23, y spacing: 12)
    - Color/scoring mismatch: JSON needs updating to match current game

  **Implementation Plan (TDD):**

  **Phase 1: Update JSON to match current game** ✅
  - [x] Update 001-classic-breakout.json with correct colors and scoring:
    - Type 1: Green (1 point)
    - Type 2: Yellow (4 points)
    - Type 3: Orange (7 points)
    - Type 4: Red (7 points)
  - [x] Add grid positioning metadata:
    - startX: 11, startY: 420
    - brickWidth: 20, brickHeight: 10
    - spacing: 3, rowSpacing: 12
  - [x] Verify layout matches: 2 red rows, 2 orange rows, 2 yellow rows, 2 green rows

  **Phase 2: Create domain models (TDD)** ✅
  - [x] Create `BrickLayoutConfig` struct (Codable)
    - Properties: levelName, mapCols, mapRows, grid positioning, brickTypes, layout
  - [x] Create `BrickTypeConfig` struct (Codable)
    - Properties: id, colorName, scoreValue
  - [x] Add `BrickTypeConfig.toNSColor()` method with tests
    - Maps "Red" → .red, "Orange" → .orange, etc.
    - Throws error for invalid colors (fail-fast)
  - [x] Add `BrickLayoutConfig.generateBricks() -> [BrickData]` with tests
    - Converts grid layout to positioned BrickData array
    - Calculates x/y from grid index and positioning metadata
  - Files: Domain/BrickLayoutConfig.swift (new) - 10 tests passing

  **Phase 3: Create JSON loader (TDD)** ✅
  - [x] Create `BrickLayoutLoader` protocol
    - Method: `func load(fileName: String) throws -> BrickLayoutConfig`
  - [x] Create `JsonBrickLayoutLoader` implementation
    - Loads JSON from Resources bundle using JSONDecoder
    - Throws BrickLayoutLoaderError for missing or invalid files
  - [x] Write tests for JsonBrickLayoutLoader
    - Test successful loading
    - Test missing file error
    - Test invalid JSON error
  - Files: Domain/BrickLayoutLoader.swift (new) - 3 tests passing

  **Phase 4: Integrate with ClassicBricksLayout (TDD)** ✅
  - [x] Update `ClassicBricksLayout` to accept `[BrickData]` in init
  - [x] Kept hardcoded layout in deprecated convenience init for backward compatibility
  - [x] Update tests to verify layout loads from injected data
  - Files: Nodes/BrickSprite.swift - 1 test passing

  **Phase 5: Wire up in production code** ✅
  - [x] Update SpriteKitNodeCreator to load from JSON
  - [x] Add error handling with fallback (empty array on error)
  - [x] Verify game still works correctly
  - Files: Nodes/SpriteKitNodeCreator.swift

  **Phase 6: Cleanup and documentation** ✅
  - [x] Deprecated old hardcoded convenience init
  - [x] Run all tests - verify everything passes (all tests passing)
  - [x] Update TODO.md to mark complete

  **Benefits After Implementation:**
  - ✅ Can create new levels by editing JSON (no code changes)
  - ✅ Separation of data (JSON) and presentation (SpriteKit)
  - ✅ Can support empty spaces in grid (use 0 for no brick)
  - ✅ Easier to test - can inject test layouts
  - ✅ ~120 lines of hardcoded positions removed

  **Files Affected:**
  - Resources/001-classic-breakout.json (update)
  - Domain/BrickLayoutConfig.swift (new)
  - Domain/BrickLayoutLoader.swift (new)
  - Domain/BrickLayoutLoaderTest.swift (new)
  - Nodes/BrickSprite.swift (refactor)
  - Nodes/SpriteKitNodeCreator.swift (update to use loader)

  **Estimated Effort:** Medium (2-3 hours with TDD)

### Architecture & Modularity (Low Priority)

#### File Organization ✅ COMPLETE
- [x] Improve file/folder organization
  - Completed:
    - ✅ UserDefaultsKeys.swift removed (debug overlay cleanup)
    - ✅ NotificationNames.swift removed (dead code cleanup)
    - ✅ Shapes.swift removed (debug overlay cleanup)
    - ✅ Physics/ folder well-organized with new configurators/appliers
    - ✅ JsonGameConfigurationLoader.swift moved to Domain/Adapters/
    - ✅ UI/ folder removed (was empty after DevSettingsView cleanup)
  - Final structure:
    - Domain/Adapters/ contains all adapter implementations
    - Physics/ contains all physics-related configurators/appliers
    - No orphaned files at root level
  - Files affected: JsonGameConfigurationLoader.swift (moved), UI/ (removed)

#### Physics Configuration Duplication ✅ REVIEWED - NO ACTION NEEDED
- [x] Reviewed PhysicsBodyConfigurers duplication (PhysicsBodyConfigurers.swift)
  - Initial concern: Five configurers with similar structure
  - Analysis findings:
    - Each configurer is only 6-11 lines (minimal code)
    - Each has distinct collision behavior crucial to game logic
    - Ball configurer is unique (dynamic, circular, complex properties)
    - Static configurers differ in collision masks (purposeful variations)
    - Code is clear, explicit, and easy to understand
  - Decision: **Keep as is** - acceptable duplication
  - Reasoning:
    - Similarity is superficial; each serves distinct game physics purpose
    - Abstraction would reduce clarity without significant benefit
    - Current structure is maintainable and self-documenting
    - No real maintenance burden at 6-11 lines per configurer
  - Files: PhysicsBodyConfigurers.swift (73 lines, well-organized)

#### Magic Numbers ✅ REVIEWED - NO ACTION NEEDED
- [x] Reviewed hardcoded magic numbers (multiple files)
  - Initial concern: Sprite sizes and boundaries hardcoded
  - Analysis findings:
    - Sprite sizes (22x10, 60x12, 8x8): Used once per sprite, define visual identity
    - Paddle boundaries (20): Clear in context, used once
    - Ball reset values (160,50 / 200,300): Already have explicit default parameters
    - Physics constants: Well-documented with comments (e.g., π/4 = "45 degrees")
  - Decision: **Keep as is** - acceptable literals
  - Reasoning:
    - Each number is clear in its usage context (locality of behavior)
    - No duplication across multiple locations
    - Not configurable game parameters (design constants)
    - No calculations or derived values
    - Extracting would reduce clarity (jump to another file to understand)
  - Exception: Extract only if values become duplicated or need relationships
  - Files: BrickSprite.swift, PaddleSprite.swift, BallSprite.swift, GameScene.swift

#### Duplicated GameState Enum ✅ REVIEWED - NO ISSUE
- [x] Reviewed GameState enum usage (GameStateService.swift, BreakoutGameEngine.swift)
  - Initial concern: Two enums with same name in different contexts
  - Investigation findings:
    - Only ONE GameState enum exists in GameStateService.swift:3
    - BreakoutGameEngine.swift:7 has property `gameState: GameState` (not enum definition)
    - BreakoutGameEngine correctly imports and uses shared GameState enum
  - Decision: **No action needed** - this is correct design
  - Reasoning:
    - No duplication exists - single enum definition properly shared
    - BreakoutGameEngine uses the enum as intended
    - This promotes consistency and type safety across the app
  - Files: GameStateService.swift (defines enum), BreakoutGameEngine.swift (uses enum)

#### Storage Abstraction ✅ COMPLETE
- [x] Move InMemoryStorage to own file (Application.swift)
  - Problem: InMemoryStorage class defined in Application.swift
  - Solution: Moved to Domain/Adapters/InMemoryStorage.swift
  - Implementation:
    - Created new file Domain/Adapters/InMemoryStorage.swift
    - Moved @Observable InMemoryStorage class from Application.swift
    - Class remains simple: single source of truth for GameState
    - NavigationCoordinator continues to observe storage directly (correct SwiftUI pattern)
    - GameStateService uses storage via InMemoryGameStateAdapter (proper domain layer)
  - Result: Better file organization, clear separation of concerns
  - Files affected: Application.swift, InMemoryStorage.swift (new)
  - Note: NavigationCoordinator accessing storage directly is correct - it needs @Observable for UI reactivity

### Physics & Gameplay
- [x] Prevent ball from moving in 90-degree trajectory (straight up) from paddle ✅ COMPLETE
  - Implemented position-based paddle bounce angle control with extracted, testable components
  - PaddleBounceCalculator: Pure velocity calculation logic (isolated, testable)
  - PaddleBounceApplier: Full integration (physics extraction + calculation + velocity application)
  - GameScene: adjustBallVelocityForPaddleHit() orchestrates, delegates to PaddleBounceApplier
  - Maximum 45° angle from vertical (reduced from 60° for better control)
  - Ball always bounces upward (clamps to paddle bounds)
  - Players can aim by hitting ball with different parts of paddle
  - Fixed critical bug: ball could bounce downward when hitting beyond paddle edge
- [x] Ball respawn logic after ballLost event ✅ COMPLETE
  - Implemented automatic ball reset when ballLost event occurs with lives remaining
  - Domain: BreakoutGameEngine sets shouldResetBall flag
  - ViewModel: Calls onBallResetNeeded callback
  - GameScene: resetBall() orchestrates timing (0.5s delay), delegates to BallResetConfigurator
  - BallResetConfigurator: Handles ball configuration (prepareForReset + performReset)
  - Extracted testable logic: position reset (160, 50), velocity (200, 300), physics properties
  - Fixed gutter physics: contactTestBitMask detects ball, collisionBitMask=0 allows pass-through
  - Delayed re-activation prevents physics interference during reset

## Current Test Coverage

**35+ passing tests** across comprehensive test suites:

**Domain Tests:**
- BreakoutGameEngineTest (8 tests)
- BricksTest (2 tests)
- ScoreCardTest (3 tests)
- LivesCardTest (3 tests)
- GameEventTest (3 tests)

**Physics Tests:**
- PaddleBounceCalculatorTest (5 tests) - Pure calculation logic
- PaddleBounceApplierTest (4 tests) - Full integration testing
- BallResetConfiguratorTest (2 tests) - Ball reset configuration

**Game Layer Tests:**
- GameViewModelTest (4 tests)
- GameSceneTest (1 test)
- GameStateServiceTest (1 test)

**Configuration Tests:**
- BrickLayoutConfigTest (6 tests)
- BrickLayoutLoaderTest (3 tests)
- BrickColorTest (5 tests)
- GameConfigurationServiceTest (2 tests)
- ConfigurationModelTest (1 test)

**UI/Navigation Tests:**
- NavigationCoordinatorTest (5 tests)
- IdleViewModelTest (1 test)

**Node Management:**
- BrickNodeManagerTest (1 test)
- PhysicsBodyConfigurersTest (2 tests)

**Other:**
- ClassicBricksLayoutTest (1 test)
- InMemoryGameStateAdapterTest (1 test)
- MappingTest (1 test)

**Architecture Benefits:**
- No SpriteKit dependencies in domain tests
- Fast, focused unit tests with instant feedback
- Extracted configurators enable isolated testing without timing dependencies
- Clear separation of concerns: calculation vs application vs orchestration

---

## Comprehensive Architecture Review (2025-11-16)

A full codebase review was conducted focusing on modularization, separation of concerns, cohesion, and Swift/SwiftUI/SpriteKit best practices.

### Overall Assessment

**Strengths:**
- ✅ Excellent domain/UI separation - pure game logic has zero UI dependencies
- ✅ Event-driven architecture with clean GameEvent-based decoupling
- ✅ Strong TDD discipline with comprehensive test coverage
- ✅ Protocol-oriented design with good abstractions
- ✅ Clear layering: Domain → Presentation → Coordination → Application

**Key Architectural Wins:**
1. Domain layer is completely independent of SpriteKit
2. Event-driven communication prevents tight coupling
3. Proper lifecycle management (UserDefaultsMonitor cleanup)
4. Good use of value types (struct) for domain models

### Critical Issues - RESOLVED ✅

- ✅ **Force unwrapping in GameConfigurationService** (crash risk) - FIXED (Commit: 368c6aa)
  - Added proper error handling with fallback configuration
  - Replaced fatalError() with throw statements

- ✅ **SwiftUI state management inconsistencies** (memory leaks) - FIXED (Commit: 92f8f8f)
  - Removed @State wrapper from @Observable viewModel
  - Fixed strong capture → weak capture in closures
  - Clarified that @State for scene is acceptable pattern

### High Priority Items Remaining

None - all high priority items have been addressed.

### Medium Priority Improvements

See "Medium Priority" section above for:
- Inconsistent ViewModel patterns
- Missing access control in domain models
- Hardcoded brick layout (should be data-driven)
- Application.swift bypassing service layer

**Completed:**
- ✅ Dead code cleanup (NotificationNames.swift removed - Commit 11dfed3)

### Low Priority Cleanups

See "Low Priority" section above for:
- File organization improvements
- Physics configuration duplication
- Magic numbers extraction

### Best Practices Summary

**What's Working Well:**
- ✅ Value types for immutable domain entities (Brick, BrickId, ScoreCard)
- ✅ Reference types where needed (GameScene, GameViewModel)
- ✅ Protocol usage for abstractions (GameEngine, GameConfigurationService)
- ✅ Extension usage for organization (GameScene MARK sections)
- ✅ Proper error handling (no more force unwrapping)
- ✅ Idiomatic SwiftUI observation patterns (@Observable without @State)
- ✅ Memory-safe closures (weak captures where needed)
- ✅ GameScene well-structured for SpriteKit (cohesive responsibilities)

**Still Needs Improvement:**
- Access control modifiers (too much public mutability)
- Consistency (ViewModel pattern differs between screens)
- Dead code removal

### Progress Summary (2025-01-16)

**Completed Today:**
1. ✅ Fixed CRITICAL force unwrapping issue
2. ✅ Fixed HIGH priority SwiftUI state management
3. ✅ Clarified GameScene architecture (not a God Object)

**Key Learnings:**
- @State for SpriteKit scene is acceptable when created once in lifecycle
- GameScene responsibilities are cohesive around scene management (well-organized with clear MARK sections)
- Debug overlay has been removed - GameScene now has clean, focused responsibilities

### Recent Refactorings (2025-11-19)

**Extracted Testable Components from GameScene:**

1. ✅ **BallResetConfigurator** (Commit: 79436af)
   - Extracted ball reset configuration logic from GameScene
   - GameScene.resetBall() reduced from 44 to 15 lines
   - Two comprehensive tests: prepareForReset(), performReset()
   - GameScene now only orchestrates timing, delegates all configuration

2. ✅ **PaddleBounceApplier** (Commit: 3df5ca1)
   - Extracted paddle bounce application logic from GameScene
   - GameScene.adjustBallVelocityForPaddleHit() reduced from 24 to 5 lines
   - Four comprehensive tests: center/left/right hits + error handling
   - Tests full integration: nodes → calculation → velocity application
   - Better coverage than PaddleBounceCalculator alone

**Pattern Established:**
- GameScene = thin orchestration layer (node access + delegation)
- Configurators/Appliers = testable logic (isolated from scene graph)
- Calculator = pure computation (no side effects)

**Benefits:**
- Fast, synchronous tests without @MainActor complexity
- No timing dependencies or SKAction delays in tests
- Clear separation: orchestration vs configuration vs calculation
- GameScene.swift reduced significantly while maintaining all functionality
- Follows Single Responsibility Principle

---

## Final Comprehensive Architecture Review (2025-11-19)

A complete codebase review was conducted examining all 41 production Swift files, focusing on Modularity, Separation of Concerns, Cohesion, and Swift/SwiftUI/SpriteKit best practices.

### Overall Assessment: **Grade A-**

**Strengths:**
- ✅ Excellent separation of concerns between domain logic and UI/framework layers
- ✅ Strong protocol-oriented design for abstraction and testability
- ✅ Pure domain models (mostly) free from framework dependencies
- ✅ Well-organized directory structure reflecting architectural boundaries
- ✅ Extensive test coverage with clear TDD approach
- ✅ Proper use of value types (structs) for data, reference types (classes) for state
- ✅ Clean dependency injection throughout
- ✅ Good use of Swift naming conventions and idiomatic patterns
- ✅ Correct @Observable pattern usage in SwiftUI
- ✅ Good memory management (weak captures in closures)
- ✅ Excellent extension usage for code organization

**SOLID Principles Assessment:**
- ✅ Single Responsibility: Most classes have one clear purpose
- ✅ Open/Closed: Good use of protocols for extension
- ✅ Liskov Substitution: Protocol implementations are properly substitutable
- ✅ Interface Segregation: Protocols are focused and minimal
- ✅ Dependency Inversion: Good use of dependency injection and abstractions

### High Priority Issues (To Address Tomorrow)

#### 1. Domain Layer Contamination with AppKit/NSColor ✅ COMPLETE
- [x] Remove NSColor from domain layer (Bricks.swift, BrickLayoutConfig.swift)
  - Problem: Domain layer imports AppKit and uses NSColor, violating framework independence
  - Impact:
    - Makes domain models platform-dependent (macOS-only)
    - Cannot port to iOS or other platforms
    - Harder to test in isolation
  - Solution:
    - Created domain-specific BrickColor enum with string-based color identifiers
    - Removed all NSColor dependencies from domain layer
    - BrickSprite now handles NSColor mapping at the presentation boundary
    - Domain layer now completely framework-independent
  - Files affected: Bricks.swift, BrickLayoutConfig.swift, BrickSprite.swift
  - Commit: 1abb86f

#### 2. Missing Access Control Modifiers ✅ COMPLETE
- [x] Add explicit access control modifiers throughout codebase
  - Problem: Most types lack explicit public/internal/private modifiers, relying on Swift's default
  - Impact:
    - Less clear API boundaries
    - Harder to understand what's intended for public use vs internal implementation
    - Makes refactoring riskier
  - Solution:
    - Added explicit `internal` modifiers to all types and public members across the entire codebase
    - Added `final` keyword to classes where appropriate to prevent unintended subclassing
    - Made implementation details `private` where appropriate
    - All API boundaries are now clearly defined and documented through access control
  - Files affected:
    - Domain layer: All core types (ScoreCard, LivesCard, Bricks, GameEvent, GameEngine, etc.)
    - Domain/Adapters: All adapter implementations
    - Physics layer: All physics calculators and configurators
    - Nodes layer: All sprites, labels, and physics body configurers
    - Game/Navigation/Idle layers: All view models and scene classes
  - Tests: All passing ✅
  - Commit: 0e7c9e9

#### 3. Tight Coupling: SpriteKitNodeCreator Hardcodes Layout File ⚠️ HIGH
- [ ] Make SpriteKitNodeCreator layout configurable via dependency injection
  - Problem: Hardcodes layout file name "001-classic-breakout" and directly instantiates JsonBrickLayoutLoader
  - Location: `/Breakout/Nodes/SpriteKitNodeCreator.swift` lines 22-30
  - Code:
    ```swift
    private func loadBrickLayout() -> [BrickData] {
        let loader = JsonBrickLayoutLoader()
        do {
            let config = try loader.load(fileName: "001-classic-breakout") // Hardcoded!
    ```
  - Impact:
    - Cannot easily switch layouts or test with different configurations
    - Violates dependency injection principle
    - Creates hidden dependency on specific JSON file
  - Recommendation: Inject layout configuration or loader through constructor
  - Files affected: SpriteKitNodeCreator.swift

#### 4. Inconsistent Error Handling Strategy ⚠️ HIGH
- [ ] Standardize error handling approach across codebase
  - Problem: Inconsistent approaches - some use try/catch with fallback defaults, others silently return empty arrays
  - Examples:
    - `SpriteKitNodeCreator.swift` line 28: Returns empty array on error (silent failure)
    - `GameConfigurationService.swift` line 16: Returns fallback config (documented)
  - Impact:
    - Difficult to debug when layouts fail to load
    - Inconsistent behavior across similar scenarios
    - No way to know if fallback was used
  - Recommendation: Define consistent error handling strategy:
    - Either propagate errors to caller
    - Or use Result<T, Error> type
    - Log errors even when using fallbacks
    - Document fallback behavior
  - Files affected: SpriteKitNodeCreator.swift, GameConfigurationService.swift

### Medium Priority Issues

#### 5. BrickData Struct Has Generated ID
- [ ] Make BrickData ID injectable rather than auto-generated
  - Problem: `BrickData` auto-generates UUIDs in struct definition (presentation-layer concern)
  - Location: `/Breakout/Nodes/BrickSprite.swift` lines 3-7
  - Impact: Mixing identity generation with data structure, harder to test with predictable IDs
  - Recommendation: Make ID a parameter of the initializer or move to factory/builder

#### 6. CollisionCategory Mask Property Is Redundant
- [ ] Remove redundant mask property or simplify implementation
  - Problem: The `mask` computed property just returns `rawValue`, adding no value
  - Location: `/Breakout/Nodes/CollisionCategory.swift` lines 9-15
  - Recommendation: Either remove and use `.rawValue` directly, or simplify to `var mask: UInt32 { rawValue }`

#### 7. Magic Numbers in GameScene and Node Classes
- [ ] Extract magic numbers to named constants or configuration
  - Problem: Hardcoded numbers for positions, sizes, velocities without named constants
  - Locations:
    - `GameScene.swift` lines 82-84: Paddle clamping margins (20)
    - `SpriteKitNodeCreator.swift`: Various position/size values
  - Impact: Harder to understand intent, difficult to maintain consistency
  - Recommendation: Extract to named constants or configuration properties

#### 8. GameViewModel Has Dual Update Mechanisms
- [ ] Consider simplifying or better documenting dual update mechanism
  - Problem: ViewModel maintains both @Observable properties AND callback closures for same data
  - Location: `/Breakout/Game/GameViewModel.swift` lines 9-16
  - Impact: Duplicate state synchronization logic, potential for inconsistency
  - Note: This is reasonable compromise for bridging SwiftUI and SpriteKit, but needs documentation
  - Recommendation:
    - Add comments explaining why both mechanisms exist
    - Consider using Combine publishers instead of closures
    - Or investigate using observation for both SwiftUI and SpriteKit updates

#### 9. WallSprite Hardcodes Node Name (Bug)
- [ ] Fix WallSprite to use correct node name
  - Problem: `WallSprite` always uses `.topWall` name regardless of which wall it represents
  - Location: `/Breakout/Nodes/WallSprite.swift` line 6
  - Impact: Bug - left, right, and gutter walls all get named "topWall", cannot distinguish walls by name
  - Recommendation: Pass the name as parameter to initializer, or remove if not needed

#### 10. Duplication in Physics Body Configurers
- [ ] Consider extracting common physics configuration pattern
  - Problem: Similar physics configuration code duplicated across multiple configurers
  - Location: `/Breakout/Nodes/PhysicsBodyConfigurers.swift`
  - Note: Previously reviewed and marked as acceptable duplication (see line 494)
  - Recommendation: Extract common configuration into helper function or builder pattern if it becomes a maintenance burden

#### 11. BrickLayoutConfig Mixes Data and Behavior
- [ ] Extract generateBricks() to separate service/factory class
  - Problem: `BrickLayoutConfig` is a Codable data structure but also contains `generateBricks()` business logic
  - Location: `/Breakout/Domain/BrickLayoutConfig.swift` lines 37-58
  - Impact: Violates Single Responsibility Principle, makes struct harder to test
  - Recommendation: Extract to separate service/factory that takes BrickLayoutConfig as input

### Low Priority Issues

#### 12. Missing Documentation
- [ ] Add documentation comments for public APIs
  - Recommendation: Add docs for public protocols, non-obvious algorithms, complex initialization

#### 13. Inconsistent Copyright Comments
- [ ] Standardize copyright header usage across all files

#### 14. Optional Chaining Could Be Simplified
- [ ] Use guard let to reduce nesting in GameViewModel
  - Location: `/Breakout/Game/GameViewModel.swift` lines 47-64

#### 15. Test Helper Classes in Production Code
- [ ] Move preview helpers to separate files or conditionally compile
  - Locations: `IdleView.swift` lines 35-45, `GameView.swift` lines 96-114
  - Recommendation: Move to preview files or wrap with `#if DEBUG`

#### 16. Inconsistent Naming: "Service" vs "Adapter"
- [ ] Clarify and document naming conventions for architectural layers
  - Issue: Some use "Service" suffix, others use "Adapter", some use "Loader"
  - Recommendation: Document conventions:
    - Services: Application/domain services (orchestration, business logic)
    - Adapters: Infrastructure adapters (I/O, persistence)
    - Loaders: Specific to loading/reading data

#### 17. GameView.setupGame Could Be Decomposed Further
- [ ] Extract callback wiring into separate method for clarity
  - Location: `/Breakout/Game/GameView.swift` lines 41-83

### Summary

**No critical blocking issues found.** The codebase demonstrates excellent software engineering practices with strong separation of concerns, clean abstractions, and proper use of Swift/SwiftUI/SpriteKit patterns.

**Priority for tomorrow:**
1. Remove NSColor from domain layer (biggest architectural improvement)
2. Add access control modifiers (clarifies API boundaries)
3. Make SpriteKitNodeCreator configurable (improves testability)
4. Standardize error handling (improves debuggability)

All other issues are refinements that can be addressed over time. The codebase is in excellent shape for continued development.
