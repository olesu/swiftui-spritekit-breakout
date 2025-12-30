import SpriteKit

struct SKGameSceneBuilder: GameSceneBuilder {
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
        bounceSpeedPolicy: BounceSpeedPolicy,
    ) {
        self.gameConfiguration = gameConfiguration
        self.collisionRouter = collisionRouter
        self.brickLayoutFactory = brickLayoutFactory
        self.session = session
        self.ballLaunchController = ballLaunchController
        self.paddleMotionController = paddleMotionController
        self.bounceSpeedPolicy = bounceSpeedPolicy
    }

    func makeScene() -> SKGameScene {
        let c = gameConfiguration

        let nodes = SceneNodes(
            paddle: PaddleSprite(
                position: CGPoint(c.sceneLayout.paddleStartPosition),
                size: CGSize(c.sceneLayout.paddleSize)
            ),
            ball: BallSprite(
                position: CGPoint(c.sceneLayout.ballStartPosition)
            ),
            bricks: brickLayoutFactory.createNodes(),
            topWall: WallSprite(
                position: c.sceneLayout.topWallPosition,
                size: c.sceneLayout.topWallSize
            ),
            leftWall: WallSprite(
                position: c.sceneLayout.leftWallPosition,
                size: c.sceneLayout.leftWallSize
            ),
            rightWall: WallSprite(
                position: c.sceneLayout.rightWallPosition,
                size: c.sceneLayout.rightWallSize
            ),
            gutter: GutterSprite(
                position: c.sceneLayout.gutterPosition,
                size: c.sceneLayout.gutterSize
            )
        )

        let paddleBounceApplier = PaddleBounceApplier(
            bounceSpeedPolicy: bounceSpeedPolicy,
            bounceCalculator: BounceCalculator()
        )

        let nodeManager = SKNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: paddleBounceApplier,
            brickLayoutFactory: brickLayoutFactory,
            nodes: nodes
        )

        let soundEffectProducer = SKSoundEffectProducer()
        let visualEffectProducer = SKVisualEffectProducer(nodeManager: nodeManager)

        let contactHandler = SKGamePhysicsContactHandler(
            collisionRouter: collisionRouter,
            nodeManager: nodeManager,
            gameEventHandler: GameEventHandler(
                gameEventSink: session,
                nodeManager: nodeManager,
                soundEffectProducer: soundEffectProducer,
                visualEffectProducer: visualEffectProducer,
            )
        )

        let scene = SKGameScene(
            size: CGSize(
                width: c.sceneWidth,
                height: c.sceneHeight
            ),
            nodes: nodes,
            ballLaunchController: ballLaunchController,
            contactHandler: contactHandler,
            gameController: GameController(
                paddleInputController: PaddleInputController(),
                gameSession: session,
                nodeManager: nodeManager
            )
        )
        scene.configureForSoundEffects(soundEffectProducer)
        scene.configureForVisualEffects(visualEffectProducer)
        return scene
    }
    
}

extension SKScene {
    fileprivate func configureForSoundEffects(_ soundEffectProducer: SKSoundEffectProducer) {
        let effectsNode = SKNode()
        effectsNode.name = "sound-effects"
        effectsNode.zPosition = 1000
        addChild(effectsNode)
        soundEffectProducer.attach(to: effectsNode)
    }
    
    fileprivate func configureForVisualEffects(_ visualEffectProducer: SKVisualEffectProducer) {
        let effectsNode = SKNode()
        effectsNode.name = "visual-effects"
        effectsNode.zPosition = 1000
        addChild(effectsNode)
        visualEffectProducer.attach(to: effectsNode)
    }
}

// TODO Move to SK <-> Domain converters group someting?!?
extension CGPoint {
    init(_ point: Point) {
        self.init(
            x: CGFloat(point.x),
            y: CGFloat(point.y)
        )
    }
}

// TODO Move to SK <-> Domain converters group someting?!?
extension CGSize {
    init(_ size: Size) {
        self.init(
            width: CGFloat(size.width),
            height: CGFloat(size.height)
        )
    }
}
