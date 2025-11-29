import Foundation

public struct GameConfiguration: Codable, Equatable {
    public let sceneWidth: CGFloat
    public let sceneHeight: CGFloat

    public let brickArea: BrickArea

    public init(sceneWidth: CGFloat, sceneHeight: CGFloat, brickArea: BrickArea) {
        self.sceneWidth = sceneWidth
        self.sceneHeight = sceneHeight
        self.brickArea = brickArea
    }
}
