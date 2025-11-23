# Enhance Winning Experience

## Problem Statement
Currently, the game end screen shows "GAME OVER" regardless of whether the player won or lost. We want to:
1. Show "YOU WON!" when the player clears all bricks
2. Show "GAME OVER" when the player runs out of lives
3. Display the final score on the end screen

## Current Architecture Gaps
- **GameViewModel** has access to the final score via the engine, but it's lost when navigating away
- **GameEndViewModel** has no way to know the game outcome (won vs lost) or final score
- No mechanism to pass data between screens during navigation

## Design Considerations

### Option A: Associated Values on Screen Enum
Change `Screen` to carry data:
```swift
enum Screen {
    case idle
    case game
    case gameEnd(score: Int, outcome: GameOutcome)
}
```
**Pros:** Explicit, type-safe data flow
**Cons:** Changes navigation API everywhere, Screen becomes data-carrying

### Option B: Shared Game Result Service
Create a service to store/retrieve game results:
```swift
protocol GameResultService {
    func save(result: GameResult)
    func getLastResult() -> GameResult?
}
```
**Pros:** Doesn't change navigation, clear separation of concerns
**Cons:** Shared mutable state, need to handle lifecycle

### Option C: Extend Existing InMemoryStorage
Add game result storage to existing `InMemoryStorage`:
```swift
storage.save(score: Int)
storage.save(outcome: GameOutcome)
```
**Pros:** Reuses existing infrastructure
**Cons:** Mixing concerns (game state vs game result), storage becomes grab-bag

## Recommended Approach: Option B (Game Result Service)

**Reasoning:**
1. Game result is a distinct concept from game state
2. It's a one-time snapshot at game end (not continuous state)
3. Clear responsibility: "persist data across screen transitions"
4. Easy to test in isolation
5. Doesn't pollute the navigation layer

## TDD Todo-List

### Phase 1: Service Layer (Test-First)
- [ ] Test: InMemoryGameResultService can save and retrieve score and outcome
  - This test will drive the creation of GameResultService protocol
  - The test will need some way to represent outcome (driving creation of that type)
  - The test will need some way to bundle score + outcome (driving creation of that type)
- [ ] Implement: Create types and service to make test pass
- [ ] Test: InMemoryGameResultService returns nil when no result exists
- [ ] Implement: Handle nil case

### Phase 2: GameViewModel Integration (Test-First)
- [ ] Test: GameViewModel saves result with correct score and "won" outcome when engine transitions to .won
  - This test drives GameViewModel needing GameResultService dependency
- [ ] Implement: Add service to GameViewModel, call save on .won
- [ ] Test: GameViewModel saves result with correct score and "lost" outcome when engine transitions to .gameOver
- [ ] Implement: Call save on .gameOver

### Phase 3: GameEndViewModel Integration (Test-First)
- [ ] Test: GameEndViewModel exposes outcome from service
  - This drives GameEndViewModel needing GameResultService dependency
- [ ] Test: GameEndViewModel exposes score from service
- [ ] Implement: GameEndViewModel reads from service and exposes data

### Phase 4: View Updates
- [ ] Update GameEndView to show "YOU WON!" when outcome is .won
- [ ] Update GameEndView to show "GAME OVER" when outcome is .lost
- [ ] Update GameEndView to display final score
- [ ] Adjust styling (gold/green gradient for won, red for lost)

### Phase 5: Wiring
- [ ] Create InMemoryGameResultService instance in Application.swift
- [ ] Pass service to GameViewModel
- [ ] Pass service to GameEndViewModel
- [ ] Manual test: Play and win, verify "YOU WON!" appears
- [ ] Manual test: Play and lose, verify "GAME OVER" appears
- [ ] Manual test: Verify correct score displays in both cases

## Notes
- Let tests drive the creation of domain models (GameResult, GameOutcome, etc.)
- Keep service simple: only stores the *last* result (no history needed for MVP)
- The service follows the same pattern as GameStateAdapter (protocol + in-memory implementation)
- Don't create anything until a test needs it

## Future Enhancements (Out of Scope)
- High score persistence
- Game statistics
- Win/loss history
- Achievements
