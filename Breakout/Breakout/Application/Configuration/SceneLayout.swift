import Foundation

struct SceneLayout: Codable, Equatable {
    let paddleStartPosition: Point
    let paddleSize: Size
    let ballStartPosition: Point
    let topWallPosition: Point
    let topWallSize: Size
    let leftWallPosition: Point
    let leftWallSize: Size
    let rightWallPosition: Point
    let rightWallSize: Size
    let gutterPosition: Point
    let gutterSize: Size
}
