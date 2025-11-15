import Testing
import Foundation

@testable import Breakout

struct BreakoutGameEngineTest {

    @Test func processBrickHitEventUpdatesScore() async throws {
        let brickId = UUID()
        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: brickId.uuidString)))

        let engine = BreakoutGameEngine(bricks: bricks)
        engine.start()

        engine.process(event: .brickHit(brickID: brickId))

        #expect(engine.currentScore > 0)
    }

    @Test func processBallLostEventDecrementsLives() async throws {
        let engine = BreakoutGameEngine(bricks: Bricks(), lives: 3)
        engine.start()

        engine.process(event: .ballLost)

        #expect(engine.remainingLives == 2)
    }

    @Test func scorePersistsAcrossMultipleBrickHits() async throws {
        let brick1Id = UUID()
        let brick2Id = UUID()
        let brick3Id = UUID()
        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: brick1Id.uuidString)))
        bricks.add(Brick(id: BrickId(of: brick2Id.uuidString)))
        bricks.add(Brick(id: BrickId(of: brick3Id.uuidString)))

        let engine = BreakoutGameEngine(bricks: bricks)
        engine.start()

        engine.process(event: .brickHit(brickID: brick1Id))
        #expect(engine.currentScore == 1)

        engine.process(event: .brickHit(brickID: brick2Id))
        #expect(engine.currentScore == 2)

        engine.process(event: .brickHit(brickID: brick3Id))
        #expect(engine.currentScore == 3)
    }

    @Test func livesCannotGoBelowZero() async throws {
        let engine = BreakoutGameEngine(bricks: Bricks(), lives: 1)
        engine.start()

        engine.process(event: .ballLost)
        #expect(engine.remainingLives == 0)

        engine.process(event: .ballLost)
        #expect(engine.remainingLives == 0)
    }

    @Test func brickHitAwardsPointsBasedOnBrickColor() async throws {
        let redBrickId = UUID()
        let orangeBrickId = UUID()
        let yellowBrickId = UUID()
        let greenBrickId = UUID()

        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: redBrickId.uuidString), color: .red))
        bricks.add(Brick(id: BrickId(of: orangeBrickId.uuidString), color: .orange))
        bricks.add(Brick(id: BrickId(of: yellowBrickId.uuidString), color: .yellow))
        bricks.add(Brick(id: BrickId(of: greenBrickId.uuidString), color: .green))

        let engine = BreakoutGameEngine(bricks: bricks)
        engine.start()

        engine.process(event: .brickHit(brickID: redBrickId))
        #expect(engine.currentScore == 7)

        engine.process(event: .brickHit(brickID: orangeBrickId))
        #expect(engine.currentScore == 14)

        engine.process(event: .brickHit(brickID: yellowBrickId))
        #expect(engine.currentScore == 18)

        engine.process(event: .brickHit(brickID: greenBrickId))
        #expect(engine.currentScore == 19)
    }

}
