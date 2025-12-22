import Foundation

struct GameConfiguration: Codable, Equatable {
    let layoutFileName: String
    let sceneWidth: CGFloat
    let sceneHeight: CGFloat

    let brickArea: BrickArea

    let sceneLayout: SceneLayout

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
            ),
            sceneLayout: SceneLayout(
                paddleStartPosition: CGPoint(x: 160, y: 40),
                paddleSize: CGSize(width: 60, height: 12),
                ballStartPosition: CGPoint(x: 160, y: 50),
                topWallPosition: CGPoint(x: 160, y: 430),
                topWallSize: CGSize(width: 320, height: 10),
                leftWallPosition: CGPoint(x: 0, y: 245),
                leftWallSize: CGSize(width: 10, height: 470),
                rightWallPosition: CGPoint(x: 320, y: 245),
                rightWallSize: CGSize(width: 10, height: 470),
                gutterPosition: CGPoint(x: 160, y: 0),
                gutterSize: CGSize(width: 320, height: 10),
            )
        )
    }
}

