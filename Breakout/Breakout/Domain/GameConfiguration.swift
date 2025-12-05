import Foundation

nonisolated struct GameConfiguration: Codable, Equatable {
    internal let sceneWidth: CGFloat
    internal let sceneHeight: CGFloat

    internal let brickArea: BrickArea
}
