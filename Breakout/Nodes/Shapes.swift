import Foundation
import SpriteKit

extension SKShapeNode {
    static func brickOverlay(in brickArea: CGRect) -> SKNode {
        let node = SKShapeNode(rect: brickArea)
        node.fillColor = .darkGray
        node.strokeColor = .darkGray
        node.alpha = 0.5
        
        return node
    }
}
