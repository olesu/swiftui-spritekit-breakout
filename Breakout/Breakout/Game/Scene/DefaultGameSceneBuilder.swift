import SpriteKit

struct DefaultGameSceneBuilder: GameSceneBuilder {
    private let gameConfigurationService: GameConfigurationService
    private let collisionRouter: CollisionRouter

    init(
        gameConfigurationService: GameConfigurationService,
        collisionRouter: CollisionRouter
    ) {
        self.gameConfigurationService = gameConfigurationService
        self.collisionRouter = collisionRouter
    }

    func makeScene(
        with nodes: [NodeNames: SKNode],
        onGameEvent: @escaping (GameEvent) -> Void,
        gameSession: GameSession,
    ) -> GameScene {
        guard let paddleNode = nodes[.paddle] as? SKSpriteNode else {
            fatalError("Missing paddle node")
        }
        let sceneWidth = gameConfigurationService.getGameConfiguration()
            .sceneWidth
        let sceneHeight = gameConfigurationService.getGameConfiguration()
            .sceneHeight

        let scene = GameScene(
            size: CGSize(width: sceneWidth, height: sceneHeight),
            nodes: nodes,
            onGameEvent: onGameEvent,
            collisionRouter: collisionRouter,
            paddleMotionController: makePaddleMotionController(
                paddleNode: paddleNode,
                sceneWidth: sceneWidth
            ),
            gameSession: gameSession
        )

        return scene
    }

    private func makePaddleMotionController(
        paddleNode: SKSpriteNode,
        sceneWidth: CGFloat
    ) -> PaddleMotionController {
        let paddleSpeed = 450.0

        let result = PaddleMotionController(
            paddle: Paddle(
                x: paddleNode.position.x,
                y: paddleNode.position.y,
                w: paddleNode.size.width,
                h: paddleNode.size.height
            ),
            speed: paddleSpeed,
            sceneWidth: sceneWidth
        )

        return result

    }

}
