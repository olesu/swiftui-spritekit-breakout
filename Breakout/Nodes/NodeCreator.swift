import Foundation
import SpriteKit
import AppKit

protocol NodeCreator {
    func createNodes(onBrickAdded: @escaping (String, NSColor) -> Void) -> [NodeNames: SKNode]
}
