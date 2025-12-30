import Foundation
import SpriteKit

protocol Sprite {
    var node: SKSpriteNode { get }
    
    func attach(to parent: SKNode)
}

extension Sprite {
    func attach(to parent: SKNode) {
        parent.addChild(node)
    }
}
