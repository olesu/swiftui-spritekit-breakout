import Testing
import Foundation

@testable import Breakout

struct BreakoutGameEngineTest {

    /*
     TDD Task List for BreakoutGameEngine:

     Core Event Processing:
     [x] Can process .brickHit event and remove brick from registry
     [x] Can process .brickHit event and update score
     [x] Can process .ballLost event and decrement lives
     [x] Ignores events when game is not in .playing state

     Scoring Integration:
     [ ] .brickHit awards correct points based on brick color/type
     [ ] Score persists across multiple brick hits
     [x] Score starts at zero for new game

     Win Condition:
     [x] Game transitions to .won when last brick is destroyed
     [ ] Game stays .playing when bricks remain after hit
     [ ] Win condition is checked after each brick hit

     Game Over Condition:
     [x] Game transitions to .gameOver when last life is lost
     [ ] Game stays .playing when lives remain after ball loss
     [ ] Game over condition is checked after ball loss

     Game State Queries:
     [x] Can query current score
     [x] Can query remaining lives
     [x] Can query remaining brick count
     [x] Can query current game status

     Game Initialization:
     [x] New game starts with specified number of lives (default 3)
     [x] New game starts with score of 0
     [x] New game starts with provided brick set
     [ ] New game starts in .ready or .idle state

     State Transitions:
     [ ] Can start game (transition from .idle to .playing)
     [ ] Can pause game (transition from .playing to .paused)
     [ ] Can resume game (transition from .paused to .playing)
     [x] Cannot process game events when .gameOver
     [x] Cannot process game events when .won

     Edge Cases:
     [ ] Processing .brickHit for non-existent brick is handled gracefully
     [ ] Lives cannot go below zero
     [ ] Multiple ball losses in quick succession handled correctly

     Next: Start with simplest - process .brickHit removes brick
     */

    @Test func processBrickHitEventRemovesBrickFromRegistry() async throws {
        let brickId = UUID()
        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: brickId.uuidString)))

        let engine = BreakoutGameEngine(bricks: bricks)

        engine.process(event: .brickHit(brickID: brickId))

        #expect(engine.remainingBrickCount == 0)
    }

    @Test func processBrickHitEventUpdatesScore() async throws {
        let brickId = UUID()
        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: brickId.uuidString)))

        let engine = BreakoutGameEngine(bricks: bricks)

        engine.process(event: .brickHit(brickID: brickId))

        #expect(engine.currentScore > 0)
    }

    @Test func processBallLostEventDecrementsLives() async throws {
        let engine = BreakoutGameEngine(bricks: Bricks(), lives: 3)

        engine.process(event: .ballLost)

        #expect(engine.remainingLives == 2)
    }

    @Test func gameTransitionsToWonWhenLastBrickDestroyed() async throws {
        let brickId = UUID()
        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: brickId.uuidString)))

        let engine = BreakoutGameEngine(bricks: bricks)

        engine.process(event: .brickHit(brickID: brickId))

        #expect(engine.currentStatus == .won)
    }

    @Test func gameTransitionsToGameOverWhenLastLifeLost() async throws {
        let engine = BreakoutGameEngine(bricks: Bricks(), lives: 1)

        engine.process(event: .ballLost)

        #expect(engine.currentStatus == .gameOver)
    }

    @Test func cannotProcessEventsWhenGameOver() async throws {
        let brickId = UUID()
        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: brickId.uuidString)))

        let engine = BreakoutGameEngine(bricks: bricks, lives: 1)

        engine.process(event: .ballLost)

        engine.process(event: .brickHit(brickID: brickId))

        #expect(engine.currentScore == 0)
        #expect(engine.remainingBrickCount == 1)
        #expect(engine.currentStatus == .gameOver)
    }

    @Test func cannotProcessEventsWhenWon() async throws {
        let brickId = UUID()
        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: brickId.uuidString)))

        let engine = BreakoutGameEngine(bricks: bricks, lives: 3)

        engine.process(event: .brickHit(brickID: brickId))

        engine.process(event: .ballLost)

        #expect(engine.remainingLives == 3)
        #expect(engine.currentStatus == .won)
    }

}
