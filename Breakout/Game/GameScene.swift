import Foundation
import SpriteKit

class GameScene: SKScene {
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
        monitorUserDefaults()
        gameNodes.values.forEach(addChild)
    }

    override func willMove(from view: SKView) {
        unmonitorUserDefaults()
    }

}

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
