# Playability Improvements

Ideas for enhancing the gameplay experience in Breakout.

## 1. Ball Speed Normalization

**Problem**: Over time, floating-point rounding errors during collisions can cause the ball to gradually speed up or slow down, creating inconsistent gameplay.

**Solution**: After each collision, normalize the velocity vector to maintain a constant ball speed throughout the game.

**Implementation**: Check ball speed after paddle/brick/wall collisions and adjust the velocity vector to maintain the target speed.

## 2. Prevent Horizontal Ball Traps

**Problem**: If the ball's angle becomes too shallow (nearly horizontal), it can bounce endlessly between left/right walls without hitting bricks or paddle, creating boring gameplay.

**Solution**: Enforce a minimum vertical velocity component. If the ball becomes too horizontal, nudge it to have more vertical motion.

**Implementation**: After collisions, check if `abs(dy) < threshold` and adjust the angle if needed to ensure the ball moves up or down meaningfully.

## 3. Pause Functionality

**Problem**: Players have no way to pause the game mid-play. If they need to step away, they must lose a life or lose the game entirely.

**Solution**: Add ESC key support to pause/resume the game. Show a "PAUSED" overlay during pause state.

**Implementation**:
- Add `paused` state to game engine
- ESC key toggles pause state
- Stop physics simulation when paused
- Show pause overlay UI
- Prevent other input during pause

## 4. Randomize Initial Ball Angle

**Problem**: The ball always starts with the same trajectory (dx: 200, dy: 300), making the start of each life predictable and repetitive.

**Solution**: Add slight randomization to the initial ball angle while keeping it generally upward.

**Implementation**: Vary the dx component within a reasonable range (e.g., -250 to 250) while maintaining upward dy.

## 5. Paddle Velocity Affects Ball

**Problem**: The paddle's motion doesn't affect the ball's bounce. Moving the paddle while hitting the ball should add "english" or spin, giving players more control.

**Solution**: When the paddle is moving, add a portion of the paddle's velocity to the ball's horizontal velocity.

**Implementation**:
- Track paddle velocity in GameView
- Pass paddle velocity to PaddleBounceApplier
- Add some percentage of paddle velocity to calculated ball velocity

## 6. Progressive Ball Speed Increase

**Problem**: The game maintains the same difficulty throughout. Classic Breakout gets more exciting as you progress by gradually increasing ball speed.

**Solution**: Incrementally increase ball speed as bricks are cleared, either per brick or per row cleared.

**Implementation**:
- Track cleared bricks/rows in game engine
- At certain milestones, increase target ball speed
- Apply speed increase after next collision
- Consider maximum speed cap to keep game playable

---

## Priority

These improvements are listed roughly in order of impact on gameplay quality. Consider implementing in order, or cherry-pick the most appealing ones first.
