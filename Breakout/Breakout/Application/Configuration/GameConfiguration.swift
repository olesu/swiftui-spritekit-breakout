import Foundation

nonisolated struct GameConfiguration: Codable, Equatable {
    let layoutFileName: String
    let sceneWidth: CGFloat
    let sceneHeight: CGFloat

    let brickArea: BrickArea
    
    static func defaultValue() -> GameConfiguration {
        GameConfiguration(
            layoutFileName: "001-classic-breakout",
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
