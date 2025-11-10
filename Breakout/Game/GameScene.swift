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

    init(size: CGSize, brickArea: CGRect, nodes: [NodeNames: SKNode], onGameEvent: @escaping (GameEvent) -> Void) {
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
        gameNodes.values.forEach(addChild)
    }

    override func willMove(from view: SKView) {
        unmonitorUserDefaults()
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
        guard let brickLayout = gameNodes[.brickLayout] else { return }

        let idString = id.uuidString
        brickLayout.children.first { $0.name == idString }?.removeFromParent()
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
