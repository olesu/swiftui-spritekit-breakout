import Foundation

struct GameConfiguration: Codable, Equatable {
    let sceneWidth: CGFloat
    let sceneHeight: CGFloat

    let brickArea: BrickArea

    let sceneLayout: SceneLayout

}

