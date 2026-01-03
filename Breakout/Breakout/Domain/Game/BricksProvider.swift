import Foundation

protocol BricksProvider {
    var bricks: [BrickId: Brick] { get }
}
