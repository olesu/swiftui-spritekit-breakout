import Foundation
import SpriteKit

protocol NodeCreator {
    func createNodes(onBrickAdded: @escaping (String, BrickColor) -> Void) -> [NodeNames: SKNode]
}
