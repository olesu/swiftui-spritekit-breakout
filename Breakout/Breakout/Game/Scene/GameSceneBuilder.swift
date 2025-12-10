import SpriteKit

protocol GameSceneBuilder {
    func makeScene(
        for session: GameSession,
    ) throws -> GameScene
}
