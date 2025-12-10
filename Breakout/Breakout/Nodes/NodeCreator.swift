import Foundation
import SpriteKit

internal protocol BrickLayoutFactory {
    func createBrickLayout() -> SKNode
}
