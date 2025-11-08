import Foundation
import SpriteKit

protocol NodeCreator {
    func createNodes(onBrickAdded: @escaping (String) -> Void) -> [NodeNames: SKNode]
}
