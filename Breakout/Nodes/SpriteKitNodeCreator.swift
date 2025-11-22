import Foundation
import SpriteKit
import AppKit
import os.log

extension BrickColor {
    internal func toNSColor() -> NSColor {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        }
    }
}

internal struct SpriteKitNodeCreator: NodeCreator {
    private let layoutFileName: String
    private let layoutLoader: BrickLayoutAdapter

    internal init(
        layoutFileName: String = "001-classic-breakout",
        layoutLoader: BrickLayoutAdapter = JsonBrickLayoutAdapter()
    ) {
        self.layoutFileName = layoutFileName
        self.layoutLoader = layoutLoader
    }

    internal func createNodes(onBrickAdded: @escaping (String, BrickColor) -> Void) -> [NodeNames: SKNode] {
        let brickLayoutData = loadBrickLayout()

        return [
            .paddle: PaddleSprite(position: CGPoint(x: 160, y: 40)),
            .brickLayout: ClassicBricksLayout(bricks: brickLayoutData, onBrickAdded: onBrickAdded),
            .scoreLabel: ScoreLabel(position: CGPoint(x: 40, y: 460)),
            .livesLabel: LivesLabel(position: CGPoint(x: 280, y: 460)),
            .ball: BallSprite(position: CGPoint(x: 160, y: 50)),
            .topWall: WallSprite(position: CGPoint(x: 160, y: 430), size: CGSize(width: 320, height: 10)),
            .leftWall: WallSprite(position: CGPoint(x: 0, y: 245), size: CGSize(width: 10, height: 470)),
            .rightWall: WallSprite(position: CGPoint(x: 320, y: 245), size: CGSize(width: 10, height: 470)),
            .gutter: GutterSprite(position: CGPoint(x: 160, y: 0), size: CGSize(width: 320, height: 10))
        ]
    }

    private func loadBrickLayout() -> [(BrickData, BrickColor)] {
        do {
            let config = try layoutLoader.load(fileName: layoutFileName)
            let domainBricks = try BrickLayoutConfig.generateBricks(from: config)
            return domainBricks.map { brick in
                let brickData = BrickData(
                    id: UUID().uuidString,
                    position: brick.position,
                    color: brick.color.toNSColor()
                )
                return (brickData, brick.color)
            }
        } catch {
            os_log(.error, "Failed to load brick layout '%{public}@': %{public}@. Using empty layout as fallback.", layoutFileName, error.localizedDescription)
            return []
        }
    }
}
