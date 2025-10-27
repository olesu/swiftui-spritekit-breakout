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

    init(size: CGSize, brickArea: CGRect) {
        self.brickAreaOverlay = SKShapeNode.brickOverlay(in: brickArea)
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        monitorUserDefaults()
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
