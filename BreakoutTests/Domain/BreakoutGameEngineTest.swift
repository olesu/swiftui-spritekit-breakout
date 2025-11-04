import Testing
import Foundation

@testable import Breakout

struct BreakoutGameEngineTest {

    /*
     TDD Task List for BreakoutGameEngine:

     Core Event Processing:
     [ ] Can process .brickHit event and remove brick from registry
     [ ] Can process .brickHit event and update score
     [ ] Can process .ballLost event and decrement lives
     [ ] Ignores events when game is not in .playing state

     Scoring Integration:
     [ ] .brickHit awards correct points based on brick color/type
     [ ] Score persists across multiple brick hits
     [ ] Score starts at zero for new game

     Win Condition:
     [ ] Game transitions to .won when last brick is destroyed
     [ ] Game stays .playing when bricks remain after hit
     [ ] Win condition is checked after each brick hit

     Game Over Condition:
     [ ] Game transitions to .gameOver when last life is lost
     [ ] Game stays .playing when lives remain after ball loss
     [ ] Game over condition is checked after ball loss

     Game State Queries:
     [ ] Can query current score
     [ ] Can query remaining lives
     [ ] Can query remaining brick count
     [ ] Can query current game status

     Game Initialization:
     [ ] New game starts with specified number of lives (default 3)
     [ ] New game starts with score of 0
     [ ] New game starts with provided brick set
     [ ] New game starts in .ready or .idle state

     State Transitions:
     [ ] Can start game (transition from .idle to .playing)
     [ ] Can pause game (transition from .playing to .paused)
     [ ] Can resume game (transition from .paused to .playing)
     [ ] Cannot process game events when .gameOver
     [ ] Cannot process game events when .won

     Edge Cases:
     [ ] Processing .brickHit for non-existent brick is handled gracefully
     [ ] Lives cannot go below zero
     [ ] Multiple ball losses in quick succession handled correctly

     Next: Start with simplest - process .brickHit removes brick
     */

}
