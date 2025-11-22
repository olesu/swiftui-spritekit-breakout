# Losing the Game

In our current implementation, a life (or ball) is lost when the ball hits the gutter. The game engine correctly tracks this and transitions to `GameState.gameOver` when all lives are lost, but the UI layer doesn't properly respond to this state change.

## Current Architecture

### Navigation vs Game State (Separated)

Our architecture now separates two distinct concerns:

**Navigation State** - Which screen to show:
- `Screen` enum (Screen.swift:4-9): `.idle` and `.game`
- `NavigationState` (observable): Tracks `currentScreen`
- `ScreenNavigationService`: Updates navigation state
- Used by: `NavigationCoordinator` to determine which view to display

**Game State** - Domain-level game session state:
- `GameState` enum (GameState.swift:4-13): `.idle`, `.playing`, `.won`, `.gameOver`
- Lives in `BreakoutGameEngine.currentState` (BreakoutGameEngine.swift:28-30)
- Persisted via `GameStateAdapter` port
- Used by: Engine to enforce game rules and state transitions

### Event Flow (Working Correctly)

When the ball hits the gutter (GameScene.swift:68-69), the following happens:

1. `onGameEvent` handler is called with `GameEvent.ballLost` (GameScene.swift:69)
2. Event flows to `GameViewModel.handleGameEvent` (GameView.swift:63-64)
3. ViewModel forwards event to game engine for processing (GameViewModel.swift:53)
4. Engine decrements lives via `LivesCard.lifeWasLost()` (BreakoutGameEngine.swift:81)
5. If lives remaining > 0: engine sets `ballResetNeeded = true` (BreakoutGameEngine.swift:86)
6. If lives remaining ≤ 0: engine transitions to `GameState.gameOver` (BreakoutGameEngine.swift:84)
7. ViewModel checks `shouldResetBall` and notifies scene via `onBallResetNeeded` callback (GameViewModel.swift:58-60)

### The Problem

The `Screen` enum (Screen.swift:4-9) only has two cases:
- `idle`: Idle/start screen, represented by `IdleView`
- `game`: Active gameplay, represented by `GameView`

This means:
- ✅ Engine correctly transitions to `.gameOver` state (BreakoutGameEngine.swift:84)
- ✅ Engine correctly persists state via adapter (BreakoutGameEngine.swift:14)
- ❌ UI continues showing `GameView` with no visual feedback
- ❌ No dedicated game-over screen exists in `Screen` enum
- ❌ No `.gameOver` screen case to navigate to
- ❌ GameViewModel doesn't observe engine state or trigger navigation
- ❌ No way to restart or return to idle state after game over

**Root cause:** GameViewModel handles events but doesn't monitor the engine's `currentState` property. When the engine transitions to `.gameOver`, nothing triggers a screen navigation.

## What Needs to Be Done

### 1. Add Game-Over Screen to Navigation

**Update Screen enum:**
```swift
internal enum Screen {
    case idle
    case game
    case gameOver  // NEW
}
```

### 2. Create GameOverView

Design question: Should we have separate `GameOverView` and `GameWonView`, or a unified `GameEndView` that handles both?

**Unified approach (recommended):**
```swift
struct GameEndView: View {
    let finalState: GameState  // .won or .gameOver
    let finalScore: Int
    let onRestart: () -> Void
    let onMainMenu: () -> Void
}
```

### 3. GameViewModel Monitors Engine State

GameViewModel needs to:
- Check `engine.currentState` after processing events
- Trigger navigation when state becomes `.gameOver` or `.won`
- Inject `ScreenNavigationService` to trigger navigation

**Pattern:**
```swift
internal func handleGameEvent(_ event: GameEvent) {
    guard let engine = engine else { return }

    engine.process(event: event)

    // Check if game ended
    if engine.currentState == .gameOver {
        screenNavigationService.navigate(to: .gameOver)
    }

    // ... rest of callback logic
}
```

### 4. Wire Dependencies

- GameView needs to inject `ScreenNavigationService` into GameViewModel
- GameViewModel needs new initializer parameter
- Application already has the service, just needs to pass it through

### 5. Implement Restart Mechanism

GameEndView buttons should:
- "Play Again": Navigate to `.game` (starts fresh game)
- "Main Menu": Navigate to `.idle`

## Design Questions

### Q1: Should navigation to `.game` always create a fresh game?

**Option A:** Navigate to `.game` always starts new game session
- Simpler: No explicit "reset" mechanism needed
- Game state gets reset when GameView appears

**Option B:** Explicit reset method in engine
- More explicit: `engine.reset()` before starting
- Clearer intent in code

**Recommendation:** Option A - GameView creates a new engine instance in `setupGame()`, so navigating to `.game` naturally creates a fresh session.

### Q2: Separate views or unified end-game view?

**Option A: Unified `GameEndView`**
- Takes `finalState: GameState` parameter
- Shows different message/styling based on `.won` vs `.gameOver`
- Single view to maintain

**Option B: Separate views**
- `GameOverView` for losses
- `GameWonView` for wins
- More explicit but duplicates structure

**Recommendation:** Option A (unified) - Different end states are just different data, not different screens.

### Q3: Where should final score/stats live?

GameEndView needs to show final score. Options:
- Read from engine via GameViewModel (requires passing through)
- Pass as parameter when navigating
- Create GameEndViewModel that reads from GameStateAdapter

**Recommendation:** Pass as parameter when navigating - simplest and explicit.

## TDD Todo List

### ✅ Completed Tests

- [x] Engine resets ball after ball lost when lives remain (BreakoutGameEngineTest.swift:91)
- [x] Engine does not reset ball when game over (BreakoutGameEngineTest.swift:100)
- [x] NavigationCoordinator shows idle screen for idle state (NavigationCoordinatorTest.swift:7)
- [x] NavigationCoordinator shows game screen for game state (NavigationCoordinatorTest.swift:15)

### 🔴 BreakoutGameEngine - End-Game State Transitions (Missing Tests)

- [ ] transitions to `.gameOver` when final life is lost
- [ ] transitions to `.won` when final brick is destroyed
- [ ] persists `.gameOver` state via adapter
- [ ] persists `.won` state via adapter
- [ ] stops processing events after transitioning to `.gameOver`
- [ ] stops processing events after transitioning to `.won`

### 🔴 Screen Enum - Add GameOver Case

- [ ] add `.gameOver` case to `Screen` enum

### 🔴 NavigationCoordinator - Game Over Screen Mapping

- [ ] shows game-over screen when NavigationState.currentScreen is `.gameOver`
- [ ] continues to show idle screen for `.idle`
- [ ] continues to show game screen for `.game`

### 🔴 GameViewModel - Engine State Monitoring & Navigation

- [ ] receives ScreenNavigationService via initializer
- [ ] navigates to `.gameOver` screen when engine transitions to `.gameOver`
- [ ] navigates to `.gameOver` screen when engine transitions to `.won`
- [ ] continues to call score/lives callbacks during gameplay
- [ ] continues to trigger ball reset when needed

### 🔴 GameView - Service Wiring

- [ ] passes ScreenNavigationService to GameViewModel
- [ ] creates fresh engine instance on appear (ensures clean state)

### 🔴 GameEndView - UI & Interaction

- [ ] displays when screen is `.gameOver`
- [ ] shows "Game Over" message for `.gameOver` state
- [ ] shows "You Won!" message for `.won` state
- [ ] displays final score
- [ ] has "Play Again" button
- [ ] has "Main Menu" button
- [ ] "Play Again" navigates to `.game`
- [ ] "Main Menu" navigates to `.idle`
- [ ] receives final state and score via initializer

### 🔴 Application - Wiring

- [ ] shows GameEndView for `.gameOver` screen
- [ ] passes ScreenNavigationService to GameEndView
- [ ] GameEndView has access to final score (design TBD)

### 🔴 Integration - Full Flow

- [ ] losing final life shows game-over screen
- [ ] destroying final brick shows won screen
- [ ] "Play Again" from game-over starts new game with reset score/lives
- [ ] "Main Menu" from game-over returns to idle screen
- [ ] "Play Again" from won screen starts new game
- [ ] "Main Menu" from won screen returns to idle screen
- [ ] game-over screen doesn't respond to paddle gestures

---

**Summary:** ~4 tests passing. ~35 tests need to be written to complete game-over functionality.

**Next Steps:**
1. Start with engine tests (verify `.gameOver` and `.won` transitions)
2. Add `.gameOver` to Screen enum
3. Implement GameViewModel state monitoring
4. Create GameEndView
5. Wire everything together in Application
