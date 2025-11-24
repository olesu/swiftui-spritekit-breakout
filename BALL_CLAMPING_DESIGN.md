# Ball Clamping Design

## Overview

Allow players to position and aim the ball before launching it. The ball starts clamped to the paddle and follows it until the player presses spacebar to launch.

## Current Behavior

1. Ball starts with initial velocity (dx: 200, dy: 300)
2. After losing a life, `BallResetConfigurator` prepares ball and reapplies velocity after 0.5s delay
3. Ball immediately flies away - player has no control over when it launches

## Proposed Behavior

1. Ball starts clamped to paddle (centered on top)
2. Ball follows paddle movement (drag or arrow keys)
3. Player positions paddle to aim
4. Player presses spacebar to launch ball
5. Ball launches with velocity based on position
6. After losing a life, ball returns to clamped state

## Architecture Changes

### GameScene (owns clamped state)

**New State:**
```swift
private var isBallClamped: Bool = true
```

**New Method:**
```swift
internal func launchBall() {
    guard isBallClamped,
          let ball = gameNodes[.ball],
          let ballBody = ball.physicsBody else { return }

    isBallClamped = false
    ballBody.velocity = CGVector(dx: 200, dy: 300)
}
```

**Modified Method:**
```swift
override func update(_ currentTime: TimeInterval) {
    if isBallClamped {
        clampBallToPaddle()
    }
}

private func clampBallToPaddle() {
    guard let ball = gameNodes[.ball],
          let paddle = gameNodes[.paddle] else { return }

    let paddleTop = paddle.position.y + paddle.frame.height / 2
    let ballRadius = ball.frame.width / 2
    ball.position = CGPoint(
        x: paddle.position.x,
        y: paddleTop + ballRadius
    )
}
```

**Modified Method:**
```swift
internal func resetBall() {
    guard let ball = gameNodes[.ball] else { return }

    ballResetConfigurator.prepareForReset(ball)
    isBallClamped = true  // Set clamped instead of applying velocity

    let waitAction = SKAction.wait(forDuration: 0.5)
    let resetAction = SKAction.run { [weak self] in
        self?.clampBallToPaddle()  // Position on paddle
    }

    ball.run(SKAction.sequence([waitAction, resetAction]))
}
```

### BallResetConfigurator (simplified)

**Modified:**
```swift
internal func prepareForReset(_ ball: SKNode) {
    guard let ballBody = ball.physicsBody else { return }
    ballBody.velocity = CGVector.zero  // Stop ball
}

internal func performReset(_ ball: SKNode) {
    // No longer needs to apply velocity
    // Just ensure ball is at center-bottom (will be repositioned by clamp)
    ball.position = CGPoint(x: 160, y: 80)
}
```

### GameView (handles spacebar during game)

**Modified:**
```swift
.onKeyPress(.space) {
    scene.launchBall()
    return .handled
}
```

**Challenge:** How to distinguish spacebar during game vs. on idle/end screens?
- GameView already has arrow key handlers in `#if os(macOS)` block
- Add spacebar handler in same block
- IdleView and GameEndView have their own spacebar handlers
- Focus management ensures only active view receives input

## State Transitions

```
[Game Start] → Ball Clamped
    ↓
[Spacebar] → Ball Launched
    ↓
[Ball Lost] → Ball Clamped (after 0.5s)
    ↓
[Spacebar] → Ball Launched
    ...
```

## Component Responsibilities

| Component | Responsibility |
|-----------|---------------|
| GameScene | Owns `isBallClamped` state, clamps ball to paddle in `update()`, provides `launchBall()` method |
| BallResetConfigurator | Stops ball velocity, positions ball at center-bottom |
| GameView | Detects spacebar during gameplay, calls `scene.launchBall()` |
| GameEngine | Unchanged - no knowledge of clamping |
| GameViewModel | Unchanged - no knowledge of clamping |

## Edge Cases

1. **Spacebar pressed when ball not clamped**: `launchBall()` should check `isBallClamped` and do nothing
2. **Paddle moves off screen bounds**: Existing paddle clamping in `movePaddle()` handles this, ball follows
3. **Ball already moving when reset called**: `prepareForReset()` sets velocity to zero
4. **Player never launches ball**: Ball sits on paddle indefinitely (acceptable behavior)
5. **Scene paused/unpaused**: Ball clamping works in `update()` which respects scene pause state

## Testing Strategy

### Unit Tests (if testable)

- Test that `launchBall()` only applies velocity when `isBallClamped` is true
- Test that `launchBall()` sets `isBallClamped` to false
- Test that calling `launchBall()` when not clamped does nothing

### Manual Testing

- Start game → ball should be clamped to paddle
- Move paddle with drag → ball should follow
- Move paddle with arrow keys → ball should follow
- Press spacebar → ball should launch
- Lose ball → after 0.5s ball should be clamped again
- Position paddle and launch → ball launches from chosen position

## Launch Velocity Strategy

**Phase 1 (Simple):**
- Always launch straight up: `CGVector(dx: 0, dy: 360)`
- Or slight random angle: `CGVector(dx: random(-100, 100), dy: 360)`

**Phase 2 (Advanced - future):**
- Launch angle based on paddle position (like paddle bounce mechanic)
- Could use `PaddleBounceCalculator` to determine launch angle
- Gives player more aiming control

**Recommendation:** Start with Phase 1 (simple straight up launch)

## Implementation Approach

1. Add clamping state and logic to GameScene
2. Modify BallResetConfigurator to stop setting velocity
3. Add spacebar handler to GameView
4. Manual test all scenarios
5. Consider unit tests for GameScene methods if needed

## Risks & Mitigations

**Risk:** Complexity in GameScene `update()` method
**Mitigation:** Keep `clampBallToPaddle()` separate, simple method

**Risk:** Spacebar conflicts between views
**Mitigation:** Focus management ensures only active view receives input

**Risk:** Ball physics behave oddly when clamped
**Mitigation:** Set velocity to zero while clamped, ball has no active physics

**Risk:** Game feels too different from current behavior
**Mitigation:** Can easily revert or make it configurable if needed

## Future Enhancements

- Visual indicator that ball is clamped (pulsing, glow, arrow)
- Sound effect on launch
- Power meter that charges while holding spacebar
- Different launch speeds based on timing
- Configurable launch angle variation

---

## Decision Points

Before implementing, decide:

1. ✅ Ball clamped on game start
2. ✅ Ball follows paddle movement
3. ✅ Spacebar launches ball
4. ⚠️ Launch straight up, or with slight randomization?
5. ⚠️ Should release of drag gesture also launch, or only spacebar?

