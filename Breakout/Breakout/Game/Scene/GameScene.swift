import AppKit
import Foundation
import SpriteKit

// Coordinates game objects, input, and session state for a Breakout scene.
///
/// GameScene owns the per-frame update loop and orchestrates paddle and ball behavior
/// through its controllers. It also reflects gameplay events into `GameSession` (e.g.,
/// brick hits, ball loss) and handles ball reset flow when the session requests it.
///
/// Responsibilities:
/// - Ticks paddle motion each frame and applies clamped X to the paddle node.
/// - Keeps a clamped ball attached to the paddle until launch (via `BallLaunchController`).
/// - Applies speed and angle adjustments when the ball hits the paddle.
/// - Initiates and completes ball resets when `GameSession.state.ballResetNeeded` is true.
///
/// Update loop:
/// - On first frame, captures the start time.
/// - Each subsequent frame computes delta time and, if not resetting, updates paddle and ball.
/// - When a reset is needed, prepares the ball, schedules a reset action, and updates session state.
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
final class GameScene: SKScene {
    private let nodeManager: NodeManager
    private let gameSession: GameSession
    private let ballLaunchController: BallLaunchController
    private let ballMotionController: BallMotionController
    private let paddleMotionController: PaddleMotionController
    private let paddleInputController: PaddleInputController
    private let paddleBounceApplier: PaddleBounceApplier
    private let contactHandler: GamePhysicsContactHandler

    private var lastUpdateTime: TimeInterval = 0

    /// Creates a game scene that orchestrates gameplay using injected collaborators.
    ///
    /// - Parameters:
    ///   - size: The scene size in points.
    ///   - paddleMotionController: Updates the logical paddle model from input each frame.
    ///   - gameSession: Owns persistent game state and reduces events.
    ///   - nodeManager: Provides the SpriteKit nodes used by the scene (paddle, ball, walls, bricks).
    ///   - ballLaunchController: Clamps, launches, and resets the ball relative to the paddle/world.
    ///   - ballMotionController: Applies speed adjustments to the ball on specific events.
    ///   - paddleInputController: Interprets user input and drives paddle motion/overrides.
    ///   - paddleBounceApplier: Adjusts the ball’s bounce vector on paddle contact.
    ///   - contactHandler: Dedicated physics contact handler assigned to `physicsWorld.contactDelegate`.
    init(
        size: CGSize,
        paddleMotionController: PaddleMotionController,
        gameSession: GameSession,
        nodeManager: NodeManager,
        ballLaunchController: BallLaunchController,
        ballMotionController: BallMotionController,
        paddleInputController: PaddleInputController,
        paddleBounceApplier: PaddleBounceApplier,
        contactHandler: GamePhysicsContactHandler
    ) {
        self.nodeManager = nodeManager
        self.ballLaunchController = ballLaunchController
        self.ballMotionController = ballMotionController
        self.paddleMotionController = paddleMotionController
        self.gameSession = gameSession
        self.paddleInputController = paddleInputController
        self.paddleBounceApplier = paddleBounceApplier
        self.contactHandler = contactHandler

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GameScene {
    /// Advances the scene by one frame, updating input-driven motion and handling resets.
    ///
    /// On the first invocation, this method initializes the timing reference and returns
    /// without updating game objects. On subsequent frames it:
    /// - Computes delta time since the previous frame.
    /// - Checks `gameSession.state.ballResetNeeded` and, if needed, initiates a local reset
    ///   (guarded by `localResetInProgress`) by calling `resetBall()` and announcing progress
    ///   to `GameSession`.
    /// - If no reset is in progress, updates the paddle motion via `PaddleMotionController`,
    ///   applies the clamped X position to the paddle node, and keeps a clamped ball attached
    ///   to the paddle via `BallLaunchController.update(ball:paddle:)`.
    /// - Updates `lastUpdateTime` at the end of the frame.
    ///
    /// - Parameter currentTime: The current system time, provided by SpriteKit, used to compute
    ///   frame delta time.
    override func update(_ currentTime: TimeInterval) {
        guard lastUpdateTime > 0 else {
            lastUpdateTime = currentTime
            return
        }

        doUpdate(deltaTime: currentTime - lastUpdateTime)

        lastUpdateTime = currentTime
    }
    
    private func doUpdate(deltaTime dt: TimeInterval) {
        if gameSession.state.ballResetNeeded {
            gameSession.announceBallResetInProgress()
            ballLaunchController.performReset(
                ball: nodeManager.ball,
                at: .init(x: size.width / 2, y: 50)
            )
            gameSession.acknowledgeBallReset()
        } else {
            paddleMotionController.update(deltaTime: dt)
            nodeManager.paddle.position.x = CGFloat(
                paddleMotionController.paddle.x
            )
            ballLaunchController.update(
                ball: nodeManager.ball,
                paddle: nodeManager.paddle
            )
        }

    }

}

// MARK: - didMove (add nodes)
extension GameScene {
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

        addChild(nodeManager.topWall)
        addChild(nodeManager.leftWall)
        addChild(nodeManager.rightWall)
        addChild(nodeManager.gutter)

        addChild(nodeManager.bricks)

        addChild(nodeManager.paddle)
        addChild(nodeManager.ball)

    }
}

// MARK: - Ball Control
extension GameScene {
    /// Launches the ball if it is currently clamped to the paddle.
    func launchBall() {
        ballLaunchController.launch(ball: nodeManager.ball)
    }

    /// Slightly increases ball speed and adjusts its bounce vector after a paddle hit.
    private func adjustBallVelocityForPaddleHit() {
        ballMotionController.update(
            ball: nodeManager.ball,
            speedMultiplier: 1.03
        )
        paddleBounceApplier.applyBounce(
            ball: nodeManager.ball,
            paddle: nodeManager.paddle
        )
    }
}

// Mark: - Paddle Intent API
extension GameScene {
    /// Moves the paddle to a world-space point (typically from mouse/touch input),
    /// temporarily overriding continuous left/right input.
    func movePaddle(to point: CGPoint) {
        paddleInputController.movePaddle(to: point)
    }

    /// Ends any temporary position override, returning control to continuous input.
    func endPaddleOverride() {
        paddleInputController.endPaddleOverride()
    }

    /// Begins continuous motion to the left.
    func pressLeft() {
        paddleInputController.pressLeft()
    }

    /// Begins continuous motion to the right.
    func pressRight() {
        paddleInputController.pressRight()
    }

    /// Stops continuous left motion if active.
    func releaseLeft() {
        paddleInputController.releaseLeft()
    }

    /// Stops continuous right motion if active.
    func releaseRight() {
        paddleInputController.releaseRight()
    }
}
