import Foundation

nonisolated struct GameConfiguration: Codable, Equatable {
    let sceneWidth: CGFloat
    let sceneHeight: CGFloat

    let brickArea: BrickArea
    
    static func defaultValue() -> GameConfiguration {
        GameConfiguration(
            sceneWidth: 320,
            sceneHeight: 480,
            brickArea: BrickArea(
                x: 20,
                y: 330,
                width: 280,
                height: 120
            )
        )
    }
}
