import SpriteKit

protocol GameSceneBuilder {
    func makeScene(
        with nodes: [NodeNames: SKNode],
        onGameEvent: @escaping (GameEvent) -> Void,
        gameSession: GameSession,
    ) -> GameScene
}
