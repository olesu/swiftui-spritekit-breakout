import SpriteKit

struct DefaultGameSceneBuilder: GameSceneBuilder {
    private let gameConfigurationService: GameConfigurationService
    private let collisionRouter: CollisionRouter
    private let nodeCreator: NodeCreator
    private let session: GameSession

    init(
        gameConfigurationService: GameConfigurationService,
        collisionRouter: CollisionRouter,
        nodeCreator: NodeCreator,
        session: GameSession
    ) {
        self.gameConfigurationService = gameConfigurationService
        self.collisionRouter = collisionRouter
        self.nodeCreator = nodeCreator
        self.session = session
    }

    func makeScene() -> GameScene {
        let nodes = nodeCreator.createNodes()

        guard let paddleNode = nodes[.paddle] as? SKSpriteNode else {
            // TODO throw instead of fatalError
            fatalError("Missing paddle node")
        }

        let c = gameConfigurationService.getGameConfiguration()
        let sceneWidth = c.sceneWidth
        let sceneHeight = c.sceneHeight
        
        let paddleMotionController = makePaddleMotionController(
            paddleNode: paddleNode,
            sceneWidth: sceneWidth
        )
        let paddleInputController = PaddleInputController(motion: paddleMotionController)

        let scene = GameScene(
            size: CGSize(width: sceneWidth, height: sceneHeight),
            nodes: nodes,
            collisionRouter: collisionRouter,
            paddleMotionController: paddleMotionController,
            gameSession: session,
            nodeManager: BrickNodeManager(nodes: nodes),
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
