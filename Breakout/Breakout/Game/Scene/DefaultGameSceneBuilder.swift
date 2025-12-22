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

        let bricks = brickLayoutFactory.createNodes()

        let topWall = WallSprite(
            position: CGPoint(x: 160, y: 430),
            size: CGSize(width: 320, height: 10)
        )
        let leftWall: SKSpriteNode = WallSprite(
            position: CGPoint(x: 0, y: 245),
            size: CGSize(width: 10, height: 470)
        )
        let rightWall: SKSpriteNode = WallSprite(
            position: CGPoint(x: 320, y: 245),
            size: CGSize(width: 10, height: 470)
        )
        let gutter: SKSpriteNode = GutterSprite(
            position: CGPoint(x: 160, y: 0),
            size: CGSize(width: 320, height: 10)
        )

        let nodes = SceneNodes(
            paddle: paddle,
            ball: ball,
            bricks: bricks,
            topWall: topWall,
            leftWall: leftWall,
            rightWall: rightWall,
            gutter: gutter,
        )

        let paddleBounceApplier = PaddleBounceApplier(
            bounceSpeedPolicy: .classic,
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
            size: CGSize(width: sceneWidth, height: sceneHeight),
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
