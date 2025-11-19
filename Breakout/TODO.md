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

#### File Organization
- [ ] Improve file/folder organization
  - Problems:
    - UserDefaultsKeys.swift at root (should be in Infrastructure)
    - NotificationNames.swift at root (should be in Infrastructure)
    - JsonGameConfigurationLoader.swift misplaced (should be in Domain/Adapters)
  - Solution:
    - Create Infrastructure folder for shared utilities
    - Move configuration loaders to appropriate folders
  - Files affected: UserDefaultsKeys.swift, NotificationNames.swift, JsonGameConfigurationLoader.swift

#### Physics Configuration Duplication
- [ ] Refactor PhysicsBodyConfigurers to reduce duplication (PhysicsBodyConfigurers.swift)
  - Problem: Five configurers in one file with repetitive implementations
  - Current: Lines 3-69 contain nearly identical patterns for Brick/Gutter/Wall
  - Impact: Code duplication reduces maintainability
  - Solution:
    - Extract common pattern to protocol with default implementation
    - OR separate files per configurer type
  - Files affected: PhysicsBodyConfigurers.swift

#### Magic Numbers
- [ ] Extract hardcoded magic numbers to constants
  - Problems:
    - Sprite sizes hardcoded (BrickSprite.swift:10-11, PaddleSprite.swift:5, BallSprite.swift:5)
    - Paddle boundaries hardcoded (GameScene.swift:103-104)
  - Solution: Create GameDimensions enum with all size constants
  - Files affected: Multiple sprite files, GameScene.swift

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
- [x] Prevent ball from moving in 90-degree trajectory (straight up) from paddle ✅ COMPLETE
  - Implemented position-based paddle bounce angle control
  - PaddleBounceCalculator: Pure calculation logic (isolated, testable)
  - Maximum 45° angle from vertical (reduced from 60° for better control)
  - Ball always bounces upward (clamps to paddle bounds)
  - Players can aim by hitting ball with different parts of paddle
  - Fixed critical bug: ball could bounce downward when hitting beyond paddle edge
- [x] Ball respawn logic after ballLost event ✅ COMPLETE
  - Implemented automatic ball reset when ballLost event occurs with lives remaining
  - Domain: BreakoutGameEngine sets shouldResetBall flag
  - ViewModel: Calls onBallResetNeeded callback
  - GameScene: resetBall() method resets position (160, 50) and velocity (200, 300)
  - Fixed gutter physics: contactTestBitMask detects ball, collisionBitMask=0 allows pass-through
  - Delayed re-activation prevents physics interference during reset

## Current Test Coverage

**12 passing tests:**
- Domain/BreakoutGameEngineTest (5 tests)
- Domain/BricksTest
- Domain/ScoreCardTest
- Domain/LivesCardTest
- Domain/GameEventTest
- Game/GameViewModelTest (3 tests)
- Game/GameSceneTest (1 test)
- Nodes/BrickNodeManagerTest (1 test)
- ConfigurationModelTest
- And others...

**Architecture Benefits:**
- No SpriteKit dependencies in domain tests
- Fast, focused unit tests
- Clear separation of concerns

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
