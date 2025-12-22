import SpriteKit

struct DefaultGameSceneBuilder: GameSceneBuilder {
    private let gameConfigurationService: GameConfigurationService
    private let collisionRouter: CollisionRouter
    private let brickLayoutFactory: BrickLayoutFactory
    private let session: GameSession
    private let ballLaunchController: BallLaunchController
    private let paddleMotionController: PaddleMotionController
    private let bounceSpeedPolicy: BounceSpeedPolicy

    init(
        gameConfigurationService: GameConfigurationService,
        collisionRouter: CollisionRouter,
        brickLayoutFactory: BrickLayoutFactory,
        session: GameSession,
        ballLaunchController: BallLaunchController,
        paddleMotionController: PaddleMotionController,
        bounceSpeedPolicy: BounceSpeedPolicy
    ) {
        self.gameConfigurationService = gameConfigurationService
        self.collisionRouter = collisionRouter
        self.brickLayoutFactory = brickLayoutFactory
        self.session = session
        self.ballLaunchController = ballLaunchController
        self.paddleMotionController = paddleMotionController
        self.bounceSpeedPolicy = bounceSpeedPolicy
    }

    func makeScene() -> GameScene {
        let c = gameConfigurationService.getGameConfiguration()

        let nodes = SceneNodes(
            paddle: PaddleSprite(
                position: c.sceneLayout.paddleStartPosition,
                size: c.sceneLayout.paddleSize,
            ),
            ball: BallSprite(position: c.sceneLayout.ballStartPosition),
            bricks: brickLayoutFactory.createNodes(),
            topWall: WallSprite(
                position: c.sceneLayout.topWallPosition,
                size: c.sceneLayout.topWallSize,
            ),
            leftWall: WallSprite(
                position: c.sceneLayout.leftWallPosition,
                size: c.sceneLayout.leftWallSize,
            ),
            rightWall: WallSprite(
                position: c.sceneLayout.rightWallPosition,
                size: c.sceneLayout.rightWallSize,
            ),
            gutter: GutterSprite(
                position: c.sceneLayout.gutterPosition,
                size: c.sceneLayout.gutterSize,
            ),
        )

        let paddleBounceApplier = PaddleBounceApplier(
            bounceSpeedPolicy: bounceSpeedPolicy,
            bounceCalculator: BounceCalculator()
        )

        let nodeManager = DefaultNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: paddleBounceApplier,
            brickLayoutFactory: brickLayoutFactory,
            nodes: nodes
        )

        let paddleInputController = PaddleInputController()

        let contactHandler = GamePhysicsContactHandler(
            collisionRouter: collisionRouter,
            gameSession: session,
            nodeManager: nodeManager
        )

        let scene = GameScene(
            size: CGSize(width: c.sceneWidth, height: c.sceneHeight),
            nodes: nodes,
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
