import Foundation
import Testing

@testable import Breakout

struct BreakoutGameEngineTest {

    // MARK: - State Transitions

    @Test func engineTransitionsToGameOverStateWhenLivesReachZero() async throws
    {
        let engine = GameEngineMother.makeEngineNearGameOver(autoStart: true)

        engine.process(event: .ballLost)

        #expect(engine.currentStatus == .gameOver)
    }

    @Test func engineTransitionsToWonStateWhenAllBricksAreBroken() async throws
    {
        let (engine, brickId) = GameEngineMother.makeEngineWithSingleBrick(
            autoStart: true
        )

        engine.process(event: .brickHit(brickID: brickId))

        #expect(engine.currentStatus == .won)
    }

    @Test func engineStopsProcessingEventsAfterGameOver() async throws {
        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: "test-brick-1"), color: .green))
        let engine = GameEngineMother.makeEngineNearGameOver(bricks: bricks, autoStart: true)

        engine.process(event: .ballLost)
        engine.process(event: .brickHit(brickID: BrickId(of: "test-brick-1")))

        #expect(engine.currentStatus == .gameOver)
    }

    // MARK: - Score Management

    @Test func processBrickHitEventUpdatesScore() async throws {
        let (engine, brickId) = GameEngineMother.makeEngineWithSingleBrick(
            autoStart: true
        )

        engine.process(event: .brickHit(brickID: brickId))

        #expect(engine.currentScore > 0)
    }

    @Test func scorePersistsAcrossMultipleBrickHits() async throws {
        let (engine, brickIds) = GameEngineMother.makeEngineWithBricks(
            colors: [.green, .green, .green],
            autoStart: true
        )

        engine.process(event: .brickHit(brickID: brickIds[0]))
        #expect(engine.currentScore == 1)

        engine.process(event: .brickHit(brickID: brickIds[1]))
        #expect(engine.currentScore == 2)

        engine.process(event: .brickHit(brickID: brickIds[2]))
        #expect(engine.currentScore == 3)
    }

    @Test func brickHitAwardsPointsBasedOnBrickColor() async throws {
        let (engine, brickIds) = GameEngineMother.makeEngineWithBricks(
            colors: [.red, .orange, .yellow, .green],
            autoStart: true
        )

        engine.process(event: .brickHit(brickID: brickIds[0]))
        #expect(engine.currentScore == 7)

        engine.process(event: .brickHit(brickID: brickIds[1]))
        #expect(engine.currentScore == 14)

        engine.process(event: .brickHit(brickID: brickIds[2]))
        #expect(engine.currentScore == 18)

        engine.process(event: .brickHit(brickID: brickIds[3]))
        #expect(engine.currentScore == 19)
    }

    // MARK: - Lives Management

    @Test func processBallLostEventDecrementsLives() async throws {
        let engine = GameEngineMother.makeEngine(lives: 3, autoStart: true)

        engine.process(event: .ballLost)

        #expect(engine.remainingLives == 2)
    }

    @Test func livesCannotGoBelowZero() async throws {
        let engine = GameEngineMother.makeEngineNearGameOver(autoStart: true)

        engine.process(event: .ballLost)
        #expect(engine.remainingLives == 0)

        engine.process(event: .ballLost)
        #expect(engine.remainingLives == 0)
    }

    // MARK: - Ball Reset Logic

    @Test func shouldResetBallAfterBallLostWhenLivesRemain() async throws {
        let engine = GameEngineMother.makeEngine(lives: 3, autoStart: true)

        engine.process(event: .ballLost)

        #expect(engine.shouldResetBall == true)
    }

    @Test func shouldNotResetBallWhenGameOver() async throws {
        let engine = GameEngineMother.makeEngineNearGameOver(autoStart: true)

        engine.process(event: .ballLost)

        #expect(engine.shouldResetBall == false)
    }

    @Test func acknowledgeBallResetClearsFlag() async throws {
        let engine = GameEngineMother.makeEngine(lives: 3, autoStart: true)

        engine.process(event: .ballLost)
        #expect(engine.shouldResetBall == true)

        engine.acknowledgeBallReset()
        #expect(engine.shouldResetBall == false)
    }

}
