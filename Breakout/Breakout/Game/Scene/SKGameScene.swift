import Foundation
import SpriteKit

// Coordinates game objects, input, and session state for a Breakout scene.
///
/// GameScene owns the SpriteKit lifecycle and delegates game logic to injected controllers.
/// It orchestrates paddle and ball behavior through its controllers and reflects gameplay events
/// into `GameSession` (e.g., brick hits, ball loss).
///
/// Responsibilities:
/// - Ticks paddle motion each frame and applies clamped X to the paddle node.
/// - Keeps a clamped ball attached to the paddle until launch (via `BallLaunchController`).
/// - Applies speed and angle adjustments when the ball hits the paddle.
/// - Delegates immediate ball resets to `GameLoopController` when `GameSession.state.ballResetNeeded` is true.
///
/// Update loop:
/// - On first frame, captures the start time.
/// - Each subsequent frame computes delta time and delegates to `GameLoopController.step(deltaTime:sceneSize:)`.
/// - The controller performs an immediate reset and updates session state when needed; otherwise it advances paddle and ball.
///
/// - Important: A dedicated `GamePhysicsContactHandler` is assigned as the
///   `physicsWorld.contactDelegate` in `didMove(to:)` and is responsible for translating
///   physics contacts into game events (e.g., brick removal, ball lost, paddle bounce).
///
/// - Note: The scene expects `NodeManager` to supply preconfigured nodes (with physics bodies
///   and categories) and uses those nodes directly.
///
/// - SeeAlso: `BallLaunchController`, `BallMotionController`, `PaddleMotionController`,
///   `PaddleInputController`, `PaddleBounceApplier`, `GameSession`, `GamePhysicsContactHandler`.
final class SKGameScene: SKScene {
    private let nodes: SceneNodes
    private let ballLaunchController: BallLaunchController
    private let contactHandler: SKGamePhysicsContactHandler
    private let gameController: GameController
    

    private var lastUpdateTime: TimeInterval = 0

    /// Creates a game scene that orchestrates gameplay using injected collaborators.
    ///
    /// - Parameters:
    ///   - size: The scene size in points.
    ///   - nodeManager: Provides the SpriteKit nodes used by the scene (paddle, ball, walls, bricks).
    ///   - ballLaunchController: Clamps, launches, and resets the ball relative to the paddle/world.
    ///   - paddleInputController: Interprets user input and drives paddle motion/overrides.
    ///   - contactHandler: Dedicated physics contact handler assigned to `physicsWorld.contactDelegate`.
    init(
        size: CGSize,
        nodes: SceneNodes,
        ballLaunchController: BallLaunchController,
        contactHandler: SKGamePhysicsContactHandler,
        gameController: GameController,
    ) {
        self.nodes = nodes
        self.ballLaunchController = ballLaunchController
        self.contactHandler = contactHandler
        self.gameController = gameController
        
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SKGameScene {
    /// Advances the scene by one frame, updating input-driven motion and handling resets.
    ///
    /// On the first invocation, this method initializes the timing reference and returns
    /// without updating game objects. On subsequent frames it:
    /// - Computes delta time since the previous frame.
    /// - Delegates to `GameLoopController.step(deltaTime:sceneSize:)` to perform per-frame updates.
    ///
    /// - Parameter currentTime: The current system time, provided by SpriteKit, used to compute
    ///   frame delta time.
    override func update(_ currentTime: TimeInterval) {
        guard lastUpdateTime > 0 else {
            lastUpdateTime = currentTime
            return
        }

        gameController.step(deltaTime: currentTime - lastUpdateTime, sceneSize: size)

        lastUpdateTime = currentTime
    }
    
}

// MARK: - didMove (add nodes)
extension SKGameScene {
    /// Called by SpriteKit after the scene has been presented by a view.
    ///
    /// This method finalizes scene setup by:
    /// - Assigning a dedicated physics contact handler as the `physicsWorld.contactDelegate`
    ///   so physics contacts can be routed through the game’s collision system.
    /// - Adding all game nodes (background, walls, gutter, bricks, paddle, ball)
    ///   provided by `NodeManager` to the scene via `addGameNodes()`.
    ///
    /// - Parameter view: The `SKView` that is now presenting this scene.
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = contactHandler
        addGameNodes()
    }

    /// Adds the background, walls, gutter, bricks, paddle, and ball nodes to the scene.
    private func addGameNodes() {
        addChild(GradientBackground.create(with: size))

        addChild(nodes.topWall)
        addChild(nodes.leftWall)
        addChild(nodes.rightWall)
        addChild(nodes.gutter)

        addChild(nodes.bricks)

        addChild(nodes.paddle)
        addChild(nodes.ball)

    }
    
}

// MARK: - Ball Control
extension SKGameScene {
    /// Launches the ball if it is currently clamped to the paddle.
    func launchBall() {
        ballLaunchController.launch(ball: nodes.ball)
    }

}

// Mark: - Paddle Intent API
extension SKGameScene {
    /// Moves the paddle to a world-space point (typically from mouse/touch input),
    /// temporarily overriding continuous left/right input.
    func movePaddle(to point: CGPoint) {
        gameController.movePaddle(to: point, sceneSize: size)
    }

    /// Ends any temporary position override, returning control to continuous input.
    func endPaddleOverride() {
        gameController.endPaddleOverride()
    }

    /// Begins continuous motion to the left.
    func pressLeft() {
        gameController.pressLeft()
    }

    /// Begins continuous motion to the right.
    func pressRight() {
        gameController.pressRight()
    }

    /// Stops continuous left motion if active.
    func releaseLeft() {
        gameController.releaseLeft()
    }

    /// Stops continuous right motion if active.
    func releaseRight() {
        gameController.releaseRight()
    }
}

