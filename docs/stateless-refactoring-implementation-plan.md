# Stateless Game Service Refactoring - Implementation Plan

## Overview
This plan transforms the stateful `BreakoutGameEngine` into a stateless, functional architecture using DDD principles. Each step follows strict TDD with one test at a time.

---

## Phase 1: Define GameState Aggregate Root

### Step 1.1: Create GameState Model
**Goal:** Define the aggregate root that consolidates all game state

**TDD Cycle:**
1. Create `GameStateTest.swift`
2. Write test: `testInitialGameState_hasDefaultValues`
   - Assert: score = 0, lives = 3, status = .idle, bricks = empty, ballResetNeeded = false
3. Create `GameState.swift` struct with properties
4. Run test → GREEN

**Implementation:**
```swift
struct GameState: Equatable {
    let score: Int
    let lives: Int
    let status: GameStatus  // Rename existing GameState enum
    let bricks: [BrickId: Brick]
    let ballResetNeeded: Bool

    static let initial = GameState(
        score: 0,
        lives: 3,
        status: .idle,
        bricks: [:],
        ballResetNeeded: false
    )
}
```

**Files to create:**
- `Breakout/Domain/GameState.swift` (new struct)
- `BreakoutTests/Domain/GameStateTest.swift`

**Files to modify:**
- Rename `GameState` enum → `GameStatus` everywhere

---

### Step 1.2: Add State Update Methods
**Goal:** Add immutable update methods to GameState

**TDD Cycles (ONE TEST AT A TIME):**

**Test 1:** `testWithScore_updatesScore_keepsOtherFieldsUnchanged`
```swift
let state = GameState.initial
let updated = state.with(score: 10)
#expect(updated.score == 10)
#expect(updated.lives == 3)  // Unchanged
```

**Test 2:** `testWithLives_updatesLives_keepsOtherFieldsUnchanged`

**Test 3:** `testWithStatus_updatesStatus_keepsOtherFieldsUnchanged`

**Test 4:** `testWithBricks_updatesBricks_keepsOtherFieldsUnchanged`

**Test 5:** `testWithBallResetNeeded_updatesBallResetFlag_keepsOtherFieldsUnchanged`

**Implementation:** Add `with` methods for each property

---

## Phase 2: Create GameService Protocol & Tests

### Step 2.1: Define GameService Protocol
**Goal:** Define the stateless service interface

**TDD Cycle:**
1. Create `GameServiceTest.swift`
2. Write test: `testStartGame_transitionsFromIdleToPlaying`
   - Given: state with status = .idle
   - When: service.startGame(state)
   - Then: new state has status = .playing
3. Create `GameService` protocol
4. Create `BreakoutGameService` stub implementation
5. Run test → GREEN

**Protocol:**
```swift
protocol GameService {
    func startGame(state: GameState) -> GameState
    func processEvent(_ event: GameEvent, state: GameState) -> GameState
}
```

**Files to create:**
- `Breakout/Domain/GameService.swift`
- `Breakout/Domain/BreakoutGameService.swift`
- `BreakoutTests/Domain/GameServiceTest.swift`

---

### Step 2.2: Implement Start Game Logic
**Goal:** Verify startGame only works from idle state

**TDD Cycles:**

**Test 1:** `testStartGame_whenAlreadyPlaying_returnsUnchangedState`

**Test 2:** `testStartGame_whenGameWon_returnsUnchangedState`

**Test 3:** `testStartGame_whenGameOver_returnsUnchangedState`

---

### Step 2.3: Implement Brick Hit Event Processing
**Goal:** Process brick hits with score calculation

**TDD Cycles (ONE AT A TIME):**

**Test 1:** `testProcessBrickHit_whenPlaying_removesBrick`
- Given: state with 1 red brick
- When: processEvent(.brickHit(brickID))
- Then: brick removed from state.bricks

**Test 2:** `testProcessBrickHit_whenPlaying_addsScoreBasedOnColor_red`
- Given: state with red brick
- When: processEvent(.brickHit)
- Then: state.score increased by 7

**Test 3:** `testProcessBrickHit_whenPlaying_addsScoreBasedOnColor_orange`
- Assert: score += 7

**Test 4:** `testProcessBrickHit_whenPlaying_addsScoreBasedOnColor_yellow`
- Assert: score += 4

**Test 5:** `testProcessBrickHit_whenPlaying_addsScoreBasedOnColor_green`
- Assert: score += 1

**Test 6:** `testProcessBrickHit_whenLastBrick_setsStatusToWon`
- Given: state with 1 brick
- When: processEvent(.brickHit)
- Then: state.status == .won

**Test 7:** `testProcessBrickHit_whenNotPlaying_returnsUnchangedState`
- Given: state with status = .idle
- When: processEvent(.brickHit)
- Then: state unchanged

**Test 8:** `testProcessBrickHit_whenBrickDoesNotExist_returnsUnchangedState`

---

### Step 2.4: Implement Ball Lost Event Processing
**Goal:** Process ball loss with lives and reset logic

**TDD Cycles:**

**Test 1:** `testProcessBallLost_whenPlaying_decrementsLives`
- Given: state with 3 lives
- When: processEvent(.ballLost)
- Then: state.lives == 2

**Test 2:** `testProcessBallLost_whenPlaying_setsBallResetNeeded`
- Then: state.ballResetNeeded == true

**Test 3:** `testProcessBallLost_whenLastLife_setsStatusToGameOver`
- Given: state with 1 life
- When: processEvent(.ballLost)
- Then: state.status == .gameOver, lives == 0

**Test 4:** `testProcessBallLost_whenLastLife_doesNotSetBallResetNeeded`
- Then: state.ballResetNeeded == false

**Test 5:** `testProcessBallLost_whenNotPlaying_returnsUnchangedState`

**Test 6:** `testProcessBallLost_whenGameOver_doesNotDecrementBelowZero`

---

### Step 2.5: Implement Ball Reset Acknowledgement
**Goal:** Clear the ball reset flag

**TDD Cycle:**

**Test 1:** `testAcknowledgeBallReset_clearsBallResetFlag`
- Given: state with ballResetNeeded = true
- When: acknowledgeBallReset(state)
- Then: state.ballResetNeeded == false

**Implementation:**
```swift
protocol GameService {
    func acknowledgeBallReset(state: GameState) -> GameState
}
```

---

## Phase 3: Create GameStateRepository

### Step 3.1: Define Repository Protocol
**Goal:** Abstract persistence layer

**TDD Cycle:**
1. Create `GameStateRepositoryTest.swift`
2. Write test: `testSaveAndLoad_persistsGameState`
   - When: repo.save(state)
   - Then: repo.load() returns same state
3. Create protocol
4. Create `InMemoryGameStateRepository`
5. Run test → GREEN

**Protocol:**
```swift
protocol GameStateRepository {
    func load() -> GameState
    func save(_ state: GameState)
}
```

**Files to create:**
- `Breakout/Domain/GameStateRepository.swift`
- `Breakout/Infrastructure/InMemoryGameStateRepository.swift`
- `BreakoutTests/Domain/GameStateRepositoryTest.swift`

---

### Step 3.2: Implement Repository Tests
**TDD Cycles:**

**Test 1:** `testLoad_whenNoStateSaved_returnsInitialState`

**Test 2:** `testSave_overwritesPreviousState`
- Save state1, save state2, load → returns state2

---

## Phase 4: Update GameViewModel to Use New Architecture

### Step 4.1: Add Dependencies to GameViewModel
**Goal:** Inject service and repository

**TDD Cycle:**
1. Modify `GameViewModelTest.swift`
2. Write test: `testInitialization_loadsStateFromRepository`
   - Given: repository with saved state
   - When: create viewModel
   - Then: viewModel reflects loaded state
3. Update `GameViewModel` initializer
4. Run test → GREEN

**Changes:**
```swift
class GameViewModel {
    private let service: GameService
    private let repository: GameStateRepository
    private var currentState: GameState

    init(
        service: GameService,
        repository: GameStateRepository,
        sceneSize: CGSize,
        brickArea: CGRect
    ) {
        self.service = service
        self.repository = repository
        self.currentState = repository.load()
        // ...
    }
}
```

---

### Step 4.2: Implement Start Game
**TDD Cycle:**

**Test 1:** `testStartGame_callsServiceAndSavesState`
- When: viewModel.startGame()
- Then: repository.load().status == .playing

**Implementation:**
```swift
func startGame() {
    currentState = service.startGame(state: currentState)
    repository.save(currentState)
}
```

---

### Step 4.3: Implement Event Processing
**TDD Cycles:**

**Test 1:** `testHandleGameEvent_brickHit_updatesScore`
- Given: state with red brick
- When: handleGameEvent(.brickHit)
- Then: currentScore == 7

**Test 2:** `testHandleGameEvent_brickHit_savesState`

**Test 3:** `testHandleGameEvent_brickHit_triggersCallbacks`
- Assert: onScoreChanged called with new score

**Test 4:** `testHandleGameEvent_ballLost_updatesLives`

**Test 5:** `testHandleGameEvent_ballLost_triggersCallbacks`
- Assert: onLivesChanged, onBallResetNeeded called

**Test 6:** `testHandleGameEvent_lastBrick_navigatesToWinScreen`

**Test 7:** `testHandleGameEvent_lastLife_navigatesToGameOverScreen`

---

### Step 4.4: Implement Ball Reset Acknowledgement
**TDD Cycle:**

**Test 1:** `testAcknowledgeBallReset_clearsResetFlag`
- When: acknowledgeBallReset()
- Then: currentState.ballResetNeeded == false

---

## Phase 5: Update GameView Integration

### Step 5.1: Initialize GameState with Bricks
**Goal:** Create initial state from brick layout

**TDD Cycle:**
1. Create `GameConfigurationServiceTest.swift` (if doesn't exist)
2. Write test: `testCreateInitialState_fromBrickLayout`
   - Given: BrickLayout with configured bricks
   - When: createInitialState(layout)
   - Then: GameState contains correct bricks
3. Implement helper
4. Run test → GREEN

**Helper:**
```swift
extension GameState {
    static func initial(withBricks bricks: [BrickId: Brick]) -> GameState {
        GameState(
            score: 0,
            lives: 3,
            status: .idle,
            bricks: bricks,
            ballResetNeeded: false
        )
    }
}
```

---

### Step 5.2: Update GameView Setup
**Goal:** Wire up new architecture in view

**Manual Changes (No tests needed for SwiftUI view):**
1. Create service and repository instances
2. Initialize GameState with bricks from layout
3. Save initial state to repository
4. Create GameViewModel with dependencies
5. Remove old engine initialization

**Code:**
```swift
struct GameView: View {
    @State private var viewModel: GameViewModel

    init() {
        let service = BreakoutGameService()
        let repository = InMemoryGameStateRepository()

        let brickLayout = BrickLayout(area: brickArea)
        let bricks = brickLayout.bricks.reduce(into: [:]) { dict, brick in
            dict[brick.id] = brick
        }
        let initialState = GameState.initial(withBricks: bricks)
        repository.save(initialState)

        self.viewModel = GameViewModel(
            service: service,
            repository: repository,
            sceneSize: sceneSize,
            brickArea: brickArea
        )
    }
}
```

---

### Step 5.3: Update Callback Wiring
**Manual Changes:**
- Ensure callbacks from viewModel to scene are connected
- Test manually: play game, verify score/lives update
- Test manually: lose ball, verify reset occurs
- Test manually: destroy all bricks, verify win screen

---

## Phase 6: Cleanup & Remove Old Code

### Step 6.1: Delete Old Implementation
**Files to delete:**
1. `BreakoutGameEngine.swift`
2. `BreakoutGameEngineTest.swift`
3. `ScoreCard.swift` (logic moved to GameService)
4. `ScoreCardTest.swift`
5. `LivesCard.swift` (logic moved to GameService)
6. `LivesCardTest.swift`
7. `Bricks.swift` (using dictionary in GameState)
8. `BricksTest.swift`
9. `GameStateAdapter.swift` (replaced by GameStateRepository)
10. `InMemoryGameStateAdapter.swift`
11. `InMemoryGameStateAdapterTest.swift`
12. `GameEngine.swift` (protocol replaced by GameService)
13. `GameEngineMother.swift` (test helper)
14. `FakeGameStateAdapter.swift` (test double)
15. `FakeGameEngine.swift` (test double)

---

### Step 6.2: Update Remaining References
**Search and replace:**
- `GameEngine` protocol → `GameService`
- Any remaining `GameStateAdapter` → `GameStateRepository`
- Rename `GameState` enum → `GameStatus` (if not done in Phase 1)

---

### Step 6.3: Verify All Tests Pass
**Commands:**
```bash
# Run full test suite
swift test

# Verify no old references remain
grep -r "BreakoutGameEngine" Breakout/
grep -r "GameStateAdapter" Breakout/
grep -r "ScoreCard" Breakout/
grep -r "LivesCard" Breakout/
```

---

## Phase 7: Manual Testing

### Test Scenarios:
1. **Start new game** - Verify transition to playing
2. **Hit bricks** - Verify score updates correctly by color
3. **Lose ball** - Verify lives decrease, ball resets
4. **Win game** - Destroy all bricks, verify win screen
5. **Lose game** - Lose all lives, verify game over screen
6. **Resume game** - Quit and restart, verify state persists

---

## Summary

**Total Estimated Tests:** ~40 new tests
- GameState: 5 tests
- GameService: 25 tests
- GameStateRepository: 3 tests
- GameViewModel: 10 tests

**Key Benefits Achieved:**
✅ Pure functions - testable without mocks
✅ Explicit state transitions
✅ Lifecycle independence
✅ Single source of truth (GameState)
✅ Repository pattern for persistence
✅ DDD aggregate root pattern

**Risk Mitigation:**
- Each phase independently testable
- Can rollback at any phase boundary
- Old tests remain green until Phase 6
- Manual testing validates integration

---

## Next Steps

1. Review this plan with stakeholders
2. Start with Phase 1, Step 1.1
3. Follow strict TDD: ONE TEST AT A TIME
4. Commit after each passing test
5. Create PR after each phase completes