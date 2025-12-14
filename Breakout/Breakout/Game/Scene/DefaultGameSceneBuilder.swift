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

        let ballLaunchController = BallLaunchController()
        let ballMotionController = BallMotionController()
        let paddleBounceApplier = PaddleBounceApplier()

        let contactHandler = GamePhysicsContactHandler(
            collisionRouter: collisionRouter,
            gameSession: session,
            nodeManager: nodeManager,
            ballMotionController: ballMotionController,
            paddleBounceApplier: paddleBounceApplier
        )
        
        let gameLoopController = GameLoopController(
            session: session,
            ballLaunch: ballLaunchController,
            paddleMotion: paddleMotionController,
            nodes: nodeManager
        )

        let scene = GameScene(
            size: CGSize(width: sceneWidth, height: sceneHeight),
            nodeManager: nodeManager,
            ballLaunchController: ballLaunchController,
            paddleInputController: paddleInputController,
            contactHandler: contactHandler,
            gameLoopController: gameLoopController
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
