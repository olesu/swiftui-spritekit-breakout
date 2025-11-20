import Foundation
import SwiftUI

@Observable internal final class GameViewModel {
    internal let configurationModel: GameConfigurationModel
    private let engineFactory: (Bricks) -> GameEngine
    private var engine: GameEngine?

    // Observable properties for SwiftUI
    private(set) internal var currentScore: Int = 0
    private(set) internal var remainingLives: Int = 3

    // Closure-based callbacks for GameScene (non-SwiftUI communication)
    internal var onScoreChanged: ((Int) -> Void)?
    internal var onLivesChanged: ((Int) -> Void)?
    internal var onBallResetNeeded: (() -> Void)?

    internal init(
        configurationModel: GameConfigurationModel,
        engineFactory: @escaping (Bricks) -> GameEngine = { bricks in BreakoutGameEngine(bricks: bricks) }
    ) {
        self.configurationModel = configurationModel
        self.engineFactory = engineFactory
    }

    internal var sceneSize: CGSize {
        configurationModel.sceneSize
    }

    internal var frameWidth: CGFloat {
        configurationModel.frameWidth
    }

    internal var frameHeight: CGFloat {
        configurationModel.frameHeight
    }

    internal var brickArea: CGRect {
        configurationModel.brickArea
    }

    internal func initializeEngine(with bricks: Bricks) {
        engine = engineFactory(bricks)
        engine?.start()
    }

    internal func handleGameEvent(_ event: GameEvent) {
        engine?.process(event: event)

        // Update observable properties and notify callbacks
        if let engine = engine {
            currentScore = engine.currentScore
            remainingLives = engine.remainingLives

            // Notify GameScene via callbacks (for non-SwiftUI updates)
            onScoreChanged?(currentScore)
            onLivesChanged?(remainingLives)

            // Handle ball reset
            if engine.shouldResetBall {
                onBallResetNeeded?()
                engine.acknowledgeBallReset()
            }
        }
    }

}
