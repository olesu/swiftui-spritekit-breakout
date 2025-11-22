# Losing the game

In our current implementation, a life (or ball) is lost when the ball hits the gutter. The game engine correctly tracks this and transitions to `GameState.gameOver` when all lives are lost, but the UI layer doesn't properly reflect this state change.

## Current Implementation

### Event Flow (Working Correctly)

When the ball hits the gutter (GameScene.swift:68-69), the following happens:

1. `onGameEvent` handler is called with `GameEvent.ballLost` (GameScene.swift:69)
2. Event flows to `GameViewModel.handleGameEvent` (GameView.swift:65-67)
3. ViewModel forwards event to game engine for processing (GameViewModel.swift:70)
4. Engine decrements lives via `LivesCard.lifeWasLost()` (BreakoutGameEngine.swift:69)
5. If lives remaining > 0: engine sets `ballResetNeeded = true` (BreakoutGameEngine.swift:74)
6. If lives remaining ≤ 0: engine transitions to `GameState.gameOver` (BreakoutGameEngine.swift:72)
7. ViewModel checks `shouldResetBall` and notifies scene via `onBallResetNeeded` callback (GameViewModel.swift:75-78)

### Current States

The `GameState` enum (GameStateService.swift:4-13) has four states:
- `idle`: Initial state, represented by `IdleView`
- `playing`: Active gameplay, represented by `GameView`
- `won`: Player destroyed all bricks (not yet fully implemented in UI)
- `gameOver`: Player lost all lives (not yet fully implemented in UI)

### The Problem

The `NavigationCoordinator` (NavigationCoordinator.swift:14-21) maps states to screens like this:

```swift
case .idle:
    return .idle
case .playing, .won, .gameOver:
    return .game  // All three map to the same screen!
```

This means:
- ✅ Engine correctly transitions to `.gameOver` state
- ❌ UI continues showing `GameView` with no visual feedback
- ❌ No dedicated game-over screen exists
- ❌ No way to restart or return to idle state after game over

## What Needs to Be Done

1. **Create dedicated end-game screens**: Either separate views for `GameOverView` and `GameWonView`, or a unified `GameEndView` that handles both cases
2. **Update NavigationCoordinator**: Map `.gameOver` and `.won` states to appropriate screen(s)
3. **Design state transition flow**: Decide how users restart after game over (see design question below)
4. **Implement restart mechanism**: Add UI controls and state service methods for transitioning back to playing/idle

## Design Question: State Transition Flow

When the game ends (`.gameOver` or `.won`), how should restart work?

**Option A: Direct restart**
- `.gameOver` → `.playing` (reset score/lives, start immediately)
- `.won` → `.playing`

**Option B: Return to idle**
- `.gameOver` → `.idle` → `.playing`
- `.won` → `.idle` → `.playing`

**Option C: Hybrid**
- Show end screen with both "Play Again" and "Main Menu" buttons
- Let user choose their path

Common patterns in classic Breakout games typically use Option C, giving players agency over what happens next.

## Other Observations

### onScoreChanged and onLivesChanged called unconditionally

`GameViewModel.handleGameEvent` (GameViewModel.swift:72-73) calls `onScoreChanged` and `onLivesChanged` unconditionally after processing every event, even if the values haven't changed. This causes unnecessary scene updates.

Potential issue: If a `ballLost` event occurs, `onScoreChanged` is called even though the score didn't change.

Should we only invoke these callbacks when values actually change?

### Ball reset logic has awkward coordination

The ball reset mechanism (GameViewModel.swift:75-78) uses a flag-based handshake:
1. Engine sets `shouldResetBall = true`
2. ViewModel checks flag and calls `onBallResetNeeded?()`
3. ViewModel immediately calls `engine.acknowledgeBallReset()` to clear the flag

This creates tight coupling between ViewModel and Engine around this specific flag. The "check flag → trigger action → acknowledge flag" pattern feels brittle - if the acknowledgement is missed or called twice, the state becomes inconsistent.

Alternative approach: Could the engine emit a different event type (e.g., `GameEvent.ballResetRequired`) instead of using a stateful flag?

### GameViewModel doesn't update its observable properties

`GameViewModel` has `currentScore` and `remainingLives` as `@Observable` properties (GameViewModel.swift:15-16), but `handleGameEvent` never updates them. It only calls the closure-based callbacks (`onScoreChanged`, `onLivesChanged`).

This means SwiftUI views can't observe score/lives changes through the ViewModel - they must be updated via the callback mechanism to GameScene labels. This limits reusability of the ViewModel for SwiftUI-only contexts.

### Consider changing some names

- RealGameStateService has an awkward ring to it. What would be a better name?

## TDD Todo List

### GameStateService - State Transitions

- [x] can transition to any state (parameterized test covers .idle, .playing, .won, .gameOver) (GameStateServiceTest.swift:7)

**Specific flow tests (may not be needed if we test illegal transitions instead):**
- [ ] can transition from game over back to idle
- [ ] can transition from won back to idle
- [ ] can transition from game over directly to playing (if we choose this approach)
- [ ] can transition from won directly to playing (if we choose this approach)

### NavigationCoordinator - Screen Mapping

- [ ] maps game over state to game over screen ⚠️ *test exists but expects wrong behavior (NavigationCoordinatorTest.swift:31)*
- [ ] maps won state to won screen (or game end screen) ⚠️ *test exists but expects wrong behavior (NavigationCoordinatorTest.swift:23)*
- [x] continues to map idle to idle screen (NavigationCoordinatorTest.swift:7)
- [x] continues to map playing to game screen (NavigationCoordinatorTest.swift:15)

### GameViewModel - Engine State Monitoring

- [ ] detects when engine transitions to game over state
- [ ] triggers GameStateService transition when engine reports game over
- [ ] detects when engine transitions to won state
- [ ] triggers GameStateService transition when engine reports won
- [ ] stops processing events after game is over
- [ ] stops processing events after game is won

### GameEndViewModel (or GameOverViewModel) - Restart Logic

- [ ] can request transition back to idle state
- [ ] can request transition directly to playing state (if we support this)
- [ ] provides current game state (won vs game over)
- [ ] provides final score
- [ ] provides game statistics (if we want to show these)

### GameOverView / GameWonView / GameEndView - UI Components

- [ ] displays when game over state is active
- [ ] displays when won state is active
- [ ] shows final score
- [ ] has "Play Again" button
- [ ] has "Main Menu" button (if we choose hybrid approach)
- [ ] triggers appropriate state transition when buttons pressed

### Integration - Full Flow

- [ ] losing final life transitions to game over screen
- [ ] destroying final brick transitions to won screen
- [ ] clicking "Play Again" from game over starts new game
- [ ] clicking "Main Menu" from game over returns to idle screen
- [ ] clicking "Play Again" from won screen starts new game
- [ ] clicking "Main Menu" from won screen returns to idle screen
- [ ] new game starts with reset score and lives
- [ ] game over screen doesn't respond to paddle gestures

### Optional - Refactoring Existing Issues

- [ ] onScoreChanged only called when score actually changes
- [ ] onLivesChanged only called when lives actually change
- [ ] GameViewModel updates its observable properties for SwiftUI

### BreakoutGameEngine - End-Game State Transitions (Missing)

These behaviors are implemented in the engine but not verified by tests:

- [ ] transitions to .gameOver state when final life is lost
- [ ] transitions to .won state when final brick is destroyed
- [x] should reset ball after ball lost when lives remain (BreakoutGameEngineTest.swift:91)
- [x] should not reset ball when game over (BreakoutGameEngineTest.swift:100)

---

**Note:** This list assumes Option C (hybrid approach) with both "Play Again" and "Main Menu" buttons. If a different approach is chosen, some tests would be modified or removed.

**Summary:** ~4 tests already exist (plus 2 that verify current wrong behavior). ~30+ tests still need to be written to complete game-over functionality.