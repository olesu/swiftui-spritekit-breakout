import SpriteKit

struct DefaultGameSceneBuilder: GameSceneBuilder {
    private let gameConfigurationService: GameConfigurationService
    private let collisionRouter: CollisionRouter
    private let brickLayoutFactory: BrickLayoutFactory
    private let session: GameSession
    private let ballLaunchController: BallLaunchController
    private let paddleMotionController: PaddleMotionController

    init(
        gameConfigurationService: GameConfigurationService,
        collisionRouter: CollisionRouter,
        brickLayoutFactory: BrickLayoutFactory,
        session: GameSession,
        ballLaunchController: BallLaunchController,
        paddleMotionController: PaddleMotionController
    ) {
        self.gameConfigurationService = gameConfigurationService
        self.collisionRouter = collisionRouter
        self.brickLayoutFactory = brickLayoutFactory
        self.session = session
        self.ballLaunchController = ballLaunchController
        self.paddleMotionController = paddleMotionController
    }

    func makeScene() -> GameScene {
        let c = gameConfigurationService.getGameConfiguration()
        let sceneWidth = c.sceneWidth
        let sceneHeight = c.sceneHeight

        let paddle = PaddleSprite(
            position: CGPoint(x: 160, y: 40),
            size: CGSize(width: 60, height: 12)
        )

        let ball = BallSprite(position: CGPoint(x: 160, y: 50))
        
        let nodes = SceneNodes(paddle: paddle)

        let paddleBounceApplier = PaddleBounceApplier(
            bounceSpeedPolicy: .classic,
            bounceCalculator: BounceCalculator()
        )

        let nodeManager = DefaultNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: paddleBounceApplier,
            brickLayoutFactory: brickLayoutFactory,
            nodes: nodes,
            ball: ball
        )

        let paddleInputController = PaddleInputController()

        let contactHandler = GamePhysicsContactHandler(
            collisionRouter: collisionRouter,
            gameSession: session,
            nodeManager: nodeManager
        )

        let scene = GameScene(
            size: CGSize(width: sceneWidth, height: sceneHeight),
            nodeManager: nodeManager,
            ballLaunchController: ballLaunchController,
            contactHandler: contactHandler,
            gameController: GameController(
                paddleInputController: paddleInputController,
                gameSession: session,
                nodeManager: nodeManager,
            ),
        )

        return scene
    }

}
