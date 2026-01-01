import Foundation
import SpriteKit

protocol Attachable {
    func attach(to parent: SKNode)
}

protocol Sprite: Attachable {
    var node: SKSpriteNode { get }
    var position: Point { get }
    var size: Size { get }

    func setPosition(_ position: Point)
}

extension Sprite {
    func attach(to parent: SKNode) {
        parent.addChild(node)
    }
}

extension Sprite {
    var position: Point {
        .init(node.position)
    }

    var size: Size {
        .init(node.size)
    }

    func setPosition(_ position: Point) {
        node.position = .init(x: CGFloat(position.x), y: CGFloat(position.y))
    }
}

private extension Point {
    init(_ cgPoint: CGPoint) {
        self.x = Double(cgPoint.x)
        self.y = Double(cgPoint.y)
    }
}

private extension Size {
    init(_ cgSize: CGSize) {
        self.width = Double(cgSize.width)
        self.height = Double(cgSize.height)
    }
}
