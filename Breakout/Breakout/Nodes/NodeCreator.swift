import Foundation
import SpriteKit

/// Protocol for creating SpriteKit nodes for the game scene.
///
/// Abstracts the creation of game objects (paddle, ball, bricks, walls, gutter)
/// from the scene setup, enabling dependency injection and testability.
internal protocol NodeCreator {
    /// Creates all SpriteKit nodes required for the game scene.
    /// - Parameter onBrickAdded: Callback invoked for each brick created, passing brick ID and color.
    /// - Returns: A dictionary mapping node names to their corresponding SKNode instances.
    func createNodes() throws -> [NodeNames: SKNode]
}
