import Foundation
import SpriteKit

class GameScene: SKScene {
    private let userDefaultsKey = "areaOverlaysEnabled"
    private var changeObserver: NSObjectProtocol?

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
        isOverlaysEnabled = UserDefaults.standard.bool(forKey: userDefaultsKey)

        changeObserver = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            
            let newValue = UserDefaults.standard.bool(forKey: self.userDefaultsKey)
            if isOverlaysEnabled != newValue {
                isOverlaysEnabled = newValue
            }

        }
    }

    override func willMove(from view: SKView) {
        NotificationCenter.default.removeObserver(self)
    }

}

extension GameScene {
    private func updateSceneOverlays() {
        if isOverlaysEnabled {
            addChild(brickAreaOverlay)
        } else {
            removeChildren(in: [brickAreaOverlay])
        }
    }
}
