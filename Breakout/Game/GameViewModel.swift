import Foundation
import SwiftUI
import SpriteKit

@Observable class GameViewModel {
    let configurationModel: GameConfigurationModel
    private let nodeCreator: NodeCreator
    private let engineFactory: (Bricks) -> GameEngine
    private var engine: GameEngine?

    // Observable properties for SwiftUI
    private(set) var currentScore: Int = 0
    private(set) var remainingLives: Int = 3

    // Closure-based callbacks for GameScene (non-SwiftUI communication)
    var onScoreChanged: ((Int) -> Void)?
    var onLivesChanged: ((Int) -> Void)?

    init(
        configurationModel: GameConfigurationModel,
        nodeCreator: NodeCreator = SpriteKitNodeCreator(),
        engineFactory: @escaping (Bricks) -> GameEngine = { bricks in BreakoutGameEngine(bricks: bricks) }
    ) {
        self.configurationModel = configurationModel
        self.nodeCreator = nodeCreator
        self.engineFactory = engineFactory
    }

    var sceneSize: CGSize {
        configurationModel.sceneSize
    }

    var frameWidth: CGFloat {
        configurationModel.frameWidth
    }

    var frameHeight: CGFloat {
        configurationModel.frameHeight
    }

    var brickArea: CGRect {
        configurationModel.brickArea
    }

    func createNodes() -> [NodeNames: SKNode] {
        var bricks = Bricks()

        let nodes = nodeCreator.createNodes { brickId, nsColor in
            let color = BrickColor(from: nsColor) ?? .green
            bricks.add(Brick(id: BrickId(of: brickId), color: color))
        }

        engine = engineFactory(bricks)
        engine?.start()

        return nodes
    }

    func handleGameEvent(_ event: GameEvent) {
        engine?.process(event: event)

        // Update observable properties and notify callbacks
        if let engine = engine {
            currentScore = engine.currentScore
            remainingLives = engine.remainingLives

            // Notify GameScene via callbacks (for non-SwiftUI updates)
            onScoreChanged?(currentScore)
            onLivesChanged?(remainingLives)
        }
    }

}
