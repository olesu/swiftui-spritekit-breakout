import Foundation

struct SceneLayout: Codable, Equatable {
    let paddleStartPosition: CGPoint
    let paddleSize: CGSize
    let ballStartPosition: CGPoint
    let topWallPosition: CGPoint
    let topWallSize: CGSize
    let leftWallPosition: CGPoint
    let leftWallSize: CGSize
    let rightWallPosition: CGPoint
    let rightWallSize: CGSize
    let gutterPosition: CGPoint
    let gutterSize: CGSize
}
