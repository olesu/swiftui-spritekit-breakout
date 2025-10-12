import Foundation
import SpriteKit

class GameScene: SKScene {
    let brickArea: CGRect
    
    init(size: CGSize, brickArea: CGRect) {
        self.brickArea = brickArea
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let brickOverlayNode = SKShapeNode(rect: brickArea)
        
        brickOverlayNode.fillColor = .darkGray
        brickOverlayNode.strokeColor = .darkGray
        brickOverlayNode.alpha = 0.5
        
        self.addChild(brickOverlayNode)
    }
}
