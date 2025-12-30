import Foundation
import SpriteKit

protocol SpriteContainer: Attachable {
    var node: SKNode { get }
    var children: [SKNode] { get }
}

extension SpriteContainer {
    func attach(to parent: SKNode) {
        parent.addChild(node)
    }
}
