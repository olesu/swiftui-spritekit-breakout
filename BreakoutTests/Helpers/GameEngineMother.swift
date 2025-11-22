import Foundation

@testable import Breakout

/// Factory for creating game engines with sensible defaults for testing.
struct GameEngineMother {
    
    /// Creates a basic engine ready for testing, with no bricks and default lives.
    static func makeEngine(
        bricks: Bricks = Bricks(),
        lives: Int = 3,
        stateAdapter: GameStateAdapter = FakeGameStateAdapter(),
        autoStart: Bool = false
    ) -> BreakoutGameEngine {
        let engine = BreakoutGameEngine(
            bricks: bricks,
            stateAdapter: stateAdapter,
            lives: lives
        )
        if autoStart {
            engine.start()
        }
        return engine
    }
    
    /// Creates an engine with a single brick of the specified color.
    static func makeEngineWithSingleBrick(
        color: BrickColor = .green,
        lives: Int = 3,
        autoStart: Bool = false
    ) -> (engine: BreakoutGameEngine, brickId: BrickId) {
        let brickId = BrickId(of: UUID().uuidString)
        var bricks = Bricks()
        bricks.add(Brick(id: brickId, color: color))
        
        let engine = makeEngine(bricks: bricks, lives: lives, autoStart: autoStart)
        return (engine, brickId)
    }
    
    /// Creates an engine with multiple bricks of different colors.
    static func makeEngineWithBricks(
        colors: [BrickColor],
        lives: Int = 3,
        autoStart: Bool = false
    ) -> (engine: BreakoutGameEngine, brickIds: [BrickId]) {
        var bricks = Bricks()
        var brickIds: [BrickId] = []
        
        for color in colors {
            let brickId = BrickId(of: UUID().uuidString)
            bricks.add(Brick(id: brickId, color: color))
            brickIds.append(brickId)
        }
        
        let engine = makeEngine(bricks: bricks, lives: lives, autoStart: autoStart)
        return (engine, brickIds)
    }
    
    /// Creates an engine on the verge of game over (1 life remaining).
    static func makeEngineNearGameOver(
        bricks: Bricks = Bricks(),
        autoStart: Bool = false
    ) -> BreakoutGameEngine {
        makeEngine(bricks: bricks, lives: 1, autoStart: autoStart)
    }
}
