import SpriteKit

struct DefaultGameSceneBuilder: GameSceneBuilder {
    private let gameConfigurationService: GameConfigurationService
    private let collisionRouter: CollisionRouter
    private let brickLayoutFactory: BrickLayoutFactory
    private let session: GameSession

    init(
        gameConfigurationService: GameConfigurationService,
        collisionRouter: CollisionRouter,
        brickLayoutFactory: BrickLayoutFactory,
        session: GameSession
    ) {
        self.gameConfigurationService = gameConfigurationService
        self.collisionRouter = collisionRouter
        self.brickLayoutFactory = brickLayoutFactory
        self.session = session
    }

    func makeScene() -> GameScene {
        let c = gameConfigurationService.getGameConfiguration()
        let sceneWidth = c.sceneWidth
        let sceneHeight = c.sceneHeight
        
        let nodeManager = DefaultNodeManager(brickLayoutFactory: brickLayoutFactory)
        
        let paddleMotionController = makePaddleMotionController(
            paddleNode: nodeManager.paddle,
            sceneWidth: sceneWidth
        )
        let paddleInputController = PaddleInputController(motion: paddleMotionController)

        let scene = GameScene(
            size: CGSize(width: sceneWidth, height: sceneHeight),
            collisionRouter: collisionRouter,
            paddleMotionController: paddleMotionController,
            gameSession: session,
            nodeManager: nodeManager,
            ballController: BallController(),
            paddleInputController: paddleInputController
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
