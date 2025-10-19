import Foundation
import SpriteKit

class GameScene: SKScene {
    private let brickAreaOverlay: SKNode
    
    private var areaOverlaysEnabled = UserDefaults.standard.bool(forKey: "areaOverlaysEnabled")
    
    init(size: CGSize, brickArea: CGRect) {
        self.brickAreaOverlay = SKShapeNode.brickOverlay(in: brickArea)
        super.init(size: size)
        
        observeAreaOverlaysEnabled()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didMove(to view: SKView) {
        showOrHideOverlays()
    }
    
}

extension GameScene {
    private func observeAreaOverlaysEnabled() {
        NotificationCenter.default.addObserver(
            forName: .areaOverlaysEnabledDidChange,
            object: nil,
            queue: .main
        ) { notification in
            if let newValue = notification.userInfo?["newValue"] as? Bool {
                self.setAreaOverlaysEnabled(newValue)
            }
        }
    }
    
    private func setAreaOverlaysEnabled(_ enabled: Bool) {
        areaOverlaysEnabled = enabled
        showOrHideOverlays()
    }
    
    private func showOrHideOverlays() {
        self.removeChildren(in: [brickAreaOverlay])
        
        if areaOverlaysEnabled {
                self.addChild(brickAreaOverlay)
        }
    }

}
