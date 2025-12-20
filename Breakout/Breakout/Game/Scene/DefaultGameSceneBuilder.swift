import SpriteKit

struct DefaultGameSceneBuilder: GameSceneBuilder {
    private let gameConfigurationService: GameConfigurationService
    private let collisionRouter: CollisionRouter
    private let brickLayoutFactory: BrickLayoutFactory
    private let session: GameSession
    private let ballLaunchController: BallLaunchController

    init(
        gameConfigurationService: GameConfigurationService,
        collisionRouter: CollisionRouter,
        brickLayoutFactory: BrickLayoutFactory,
        session: GameSession,
        ballLaunchController: BallLaunchController
    ) {
        self.gameConfigurationService = gameConfigurationService
        self.collisionRouter = collisionRouter
        self.brickLayoutFactory = brickLayoutFactory
        self.session = session
        self.ballLaunchController = ballLaunchController
    }

    func makeScene() -> GameScene {
        let c = gameConfigurationService.getGameConfiguration()
        let sceneWidth = c.sceneWidth
        let sceneHeight = c.sceneHeight

        let nodeManager = DefaultNodeManager(
            ballLaunchController: ballLaunchController,
            brickLayoutFactory: brickLayoutFactory
        )

        let paddleMotionController = makePaddleMotionController(
            paddle: nodeManager.paddle,
            sceneWidth: sceneWidth
        )
        let paddleInputController = PaddleInputController()

        let ballMotionController = BallMotionController()
        let paddleBounceApplier = PaddleBounceApplier()

        let contactHandler = GamePhysicsContactHandler(
            collisionRouter: collisionRouter,
            gameSession: session,
            nodeManager: nodeManager,
            ballMotionController: ballMotionController,
            paddleBounceApplier: paddleBounceApplier
        )

        let scene = GameScene(
            size: CGSize(width: sceneWidth, height: sceneHeight),
            nodeManager: nodeManager,
            ballLaunchController: ballLaunchController,
            contactHandler: contactHandler,
            gameController: GameController(
                paddleInputController: paddleInputController,
                paddleMotionController: paddleMotionController,
                gameSession: session,
                nodeManager: nodeManager,
            ),
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
                w: paddle.size.width
            ),
            speed: paddleSpeed,
            sceneWidth: sceneWidth
        )

        return result
    }
}
