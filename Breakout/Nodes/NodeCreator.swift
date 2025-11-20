import Foundation
import SpriteKit

internal protocol NodeCreator {
    func createNodes(onBrickAdded: @escaping (String, BrickColor) -> Void) -> [NodeNames: SKNode]
}
