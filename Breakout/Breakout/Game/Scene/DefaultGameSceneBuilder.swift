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
            paddle: nodeManager.paddle,
            sceneWidth: sceneWidth
        )
        let paddleInputController = PaddleInputController(motion: paddleMotionController)

        let scene = GameScene(
            size: CGSize(width: sceneWidth, height: sceneHeight),
            collisionRouter: collisionRouter,
            paddleMotionController: paddleMotionController,
            gameSession: session,
            nodeManager: nodeManager,
            ballLaunchController: BallLaunchController(),
            ballMotionController: BallMotionController(),
            paddleInputController: paddleInputController
        )

        return scene
    }

    private func makePaddleMotionController(
        paddle: SKSpriteNode,
        sceneWidth: CGFloat
    ) -> PaddleMotionController {
        let paddleSpeed = 450.0

        let result = PaddleMotionController(
            paddle: Paddle(
                x: paddle.position.x,
                w: paddle.size.width,
            ),
            speed: paddleSpeed,
            sceneWidth: sceneWidth
        )

        return result

    }

}
