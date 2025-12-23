import SpriteKit

struct DefaultGameSceneBuilder: GameSceneBuilder {
    private let gameConfiguration: GameConfiguration
    private let collisionRouter: CollisionRouter
    private let brickLayoutFactory: BrickLayoutFactory
    private let session: GameSession
    private let ballLaunchController: BallLaunchController
    private let paddleMotionController: PaddleMotionController
    private let bounceSpeedPolicy: BounceSpeedPolicy

    init(
        gameConfiguration: GameConfiguration,
        collisionRouter: CollisionRouter,
        brickLayoutFactory: BrickLayoutFactory,
        session: GameSession,
        ballLaunchController: BallLaunchController,
        paddleMotionController: PaddleMotionController,
        bounceSpeedPolicy: BounceSpeedPolicy
    ) {
        self.gameConfiguration = gameConfiguration
        self.collisionRouter = collisionRouter
        self.brickLayoutFactory = brickLayoutFactory
        self.session = session
        self.ballLaunchController = ballLaunchController
        self.paddleMotionController = paddleMotionController
        self.bounceSpeedPolicy = bounceSpeedPolicy
    }

    func makeScene() -> GameScene {
        let nodes = SceneNodes(
            paddle: PaddleSprite(
                position: gameConfiguration.sceneLayout.paddleStartPosition,
                size: gameConfiguration.sceneLayout.paddleSize,
            ),
            ball: BallSprite(position: gameConfiguration.sceneLayout.ballStartPosition),
            bricks: brickLayoutFactory.createNodes(),
            topWall: WallSprite(
                position: gameConfiguration.sceneLayout.topWallPosition,
                size: gameConfiguration.sceneLayout.topWallSize,
            ),
            leftWall: WallSprite(
                position: gameConfiguration.sceneLayout.leftWallPosition,
                size: gameConfiguration.sceneLayout.leftWallSize,
            ),
            rightWall: WallSprite(
                position: gameConfiguration.sceneLayout.rightWallPosition,
                size: gameConfiguration.sceneLayout.rightWallSize,
            ),
            gutter: GutterSprite(
                position: gameConfiguration.sceneLayout.gutterPosition,
                size: gameConfiguration.sceneLayout.gutterSize,
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
            size: CGSize(width: gameConfiguration.sceneWidth, height: gameConfiguration.sceneHeight),
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
