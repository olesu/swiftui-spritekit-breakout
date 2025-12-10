import SpriteKit

protocol GameSceneBuilder {
    func makeScene(
        with nodes: [NodeNames: SKNode],
        gameSession: GameSession,
    ) -> GameScene
}
