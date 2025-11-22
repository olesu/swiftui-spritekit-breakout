# Losing the game

In our current implementation, a life (or ball) is lost when the ball hits the gutter. But when the final ball is lost, nothing really happens.

## Observations

In the current implementation, when the ball hits the gutter (coded in a `GameScene` extension which handles physics), the
`onGameEvent` handler is called with the `GameEvent.ballLost` event. The event handler in the view is set up to call the view model's `handleGameEvent` function. 

The `handleGameEvent` function forwards the event to the game engine for processing and then notifies observers (via callbacks). If the engine has signaled a need for resetting the ball via its `shouldResetBall` property, the scene is notified via the `onBallResetNeeded` callback.

## Current States

We have an initial state `GameState.idle` where we start the game. This state is represented by the `IdleView`.

When the player starts the game, we transition to the `GameState.playing` state which is represented by the `GameView`.

## Next state

When the player has lost all lives/balls, we want the game to transition to `GameState.gameOver` and the `GameOverView` (which does not exist yet) should activate.

A little dilemma: Does it make sense to transition directly from `GameState.gameOver` to `GameState.playing` if the user wants to play another game. Or does it make more sense to transition back to `GameState.idle` first? How do we design a natural flow here? What are common solutions?

## Other Observations

### onScoreChanged and onLivesChanged called unconditionally

`handleGameEvent` calls `onScoreChanged` and `onLivesChanged` unconditionally. Is this the desired behaviour, or do we only want this to happen when the score or lives are actually changed?

### reset ball logic seems a little complex

If `shouldResetBall` is set, we notify the scene through the `onBallResetNeeded` callback and then we notify the engine that we have called the `onBallResetNeeded`. I am sure this is necessary, but it seems rather awkward and brittle.