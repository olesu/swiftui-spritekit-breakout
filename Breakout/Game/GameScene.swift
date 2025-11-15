import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let userDefaultsKey = UserDefaultsKeys.areaOverlaysEnabled
    private var settingsMonitor: UserDefaultsMonitor? = nil
    private var isOverlaysEnabled: Bool = false {
        didSet {
            updateSceneOverlays()
        }
    }

    private let brickAreaOverlay: SKNode
    private let gameNodes: [NodeNames: SKNode]
    private let onGameEvent: (GameEvent) -> Void
    private var brickNodeManager: BrickNodeManager?

    init(
        size: CGSize,
        brickArea: CGRect,
        nodes: [NodeNames: SKNode],
        onGameEvent: @escaping (GameEvent) -> Void
    ) {
        self.brickAreaOverlay = SKShapeNode.brickOverlay(in: brickArea)
        self.gameNodes = nodes
        self.onGameEvent = onGameEvent
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        monitorUserDefaults()
        monitorPaddleControl()
        gameNodes.values.forEach(addChild)

        if let brickLayout = gameNodes[.brickLayout] {
            brickNodeManager = BrickNodeManager(brickLayout: brickLayout)
        }
    }

    override func willMove(from view: SKView) {
        unmonitorUserDefaults()
        unmonitorPaddleControl()
    }

    private var paddleObserver: NSObjectProtocol?

    private func monitorPaddleControl() {
        paddleObserver = NotificationCenter.default.addObserver(
            forName: .paddlePositionChanged,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let location = notification.userInfo?["location"] as? CGPoint {
                self?.movePaddle(to: location)
            }
        }
    }

    private func unmonitorPaddleControl() {
        if let observer = paddleObserver {
            NotificationCenter.default.removeObserver(observer)
            paddleObserver = nil
        }
    }

}

// MARK: - UI Updates
extension GameScene {
    func updateScore(_ score: Int) {
        if let scoreLabel = gameNodes[.scoreLabel] as? ScoreLabel {
            scoreLabel.text = String(format: "%02d", score)
        }
    }

    func updateLives(_ lives: Int) {
        if let livesLabel = gameNodes[.livesLabel] as? LivesLabel {
            livesLabel.text = "\(lives)"
        }
    }
}

// MARK: - Physics Contact Delegate
extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // Ball + Brick collision
        if contactMask == (CollisionCategory.ball.mask | CollisionCategory.brick.mask) {
            let brickNode = contact.bodyA.categoryBitMask == CollisionCategory.brick.mask ? contact.bodyA.node : contact.bodyB.node

            if let brickIdString = brickNode?.name,
               let brickId = UUID(uuidString: brickIdString) {
                onGameEvent(.brickHit(brickID: brickId))
                removeBrick(id: brickId)
            }
        }

        // Ball + Gutter collision
        if contactMask == (CollisionCategory.ball.mask | CollisionCategory.gutter.mask) {
            onGameEvent(.ballLost)
        }
    }
}

// MARK: - Brick Management
extension GameScene {
    func removeBrick(id: UUID) {
        brickNodeManager?.remove(brickId: id)
    }
}


// MARK: - Paddle Control
extension GameScene {
    func movePaddle(to location: CGPoint) {
        guard let paddle = gameNodes[.paddle] else { return }

        // Clamp paddle position to stay within scene bounds
        // Assuming paddle width is ~40, keep it within reasonable bounds
        let minX: CGFloat = 20
        let maxX: CGFloat = size.width - 20
        let clampedX = max(minX, min(maxX, location.x))

        paddle.position.x = clampedX
    }
}

// MARK: - User Defaults Monitoring
extension GameScene {
    private func monitorUserDefaults() {
        settingsMonitor = UserDefaultsMonitor(
            key: userDefaultsKey,
            initialValue: UserDefaults.standard.bool(forKey: userDefaultsKey)
        ) { [weak self] newValue in
            self?.isOverlaysEnabled = newValue
        }
    }

    private func unmonitorUserDefaults() {
        settingsMonitor = nil
    }

    private func updateSceneOverlays() {
        if isOverlaysEnabled {
            if brickAreaOverlay.parent == nil {
                addChild(brickAreaOverlay)
            }
        } else {
            if brickAreaOverlay.parent != nil {
                brickAreaOverlay.removeFromParent()
            }
        }
    }
}
