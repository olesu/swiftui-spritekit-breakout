import Foundation
import SwiftUI

@Observable class GameViewModel {
    let configurationModel: GameConfigurationModel
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
        engineFactory: @escaping (Bricks) -> GameEngine = { bricks in BreakoutGameEngine(bricks: bricks) }
    ) {
        self.configurationModel = configurationModel
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

    func initializeEngine(with bricks: Bricks) {
        engine = engineFactory(bricks)
        engine?.start()
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
