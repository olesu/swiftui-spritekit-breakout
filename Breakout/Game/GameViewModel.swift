import Foundation
import SwiftUI

/// Coordinates between the SwiftUI view layer and the domain game engine.
///
/// Maintains observable state for SwiftUI views and provides callbacks for
/// SpriteKit GameScene updates. Bridges the gap between declarative SwiftUI
/// and imperative SpriteKit.
@Observable internal final class GameViewModel {
    internal let configurationModel: GameConfigurationModel
    private var engine: GameEngine?

    // Observable properties for SwiftUI
    private(set) internal var currentScore: Int = 0
    private(set) internal var remainingLives: Int = 3

    // Closure-based callbacks for GameScene (non-SwiftUI communication)
    internal var onScoreChanged: ((Int) -> Void)?
    internal var onLivesChanged: ((Int) -> Void)?
    internal var onBallResetNeeded: (() -> Void)?

    /// Initializes the view model with configuration.
    /// - Parameters:
    ///   - configurationModel: Model providing scene dimensions and layout configuration.
    internal init(configurationModel: GameConfigurationModel) {
        self.configurationModel = configurationModel
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

    /// Sets the game engine for this view model.
    /// - Parameter engine: The game engine instance to use.
    internal func setEngine(_ engine: GameEngine) {
        self.engine = engine
    }

    /// Handles a game event from the SpriteKit layer.
    ///
    /// Processes the event through the game engine, updates observable properties
    /// for SwiftUI, invokes callbacks for SpriteKit scene updates, and triggers
    /// ball reset if needed.
    /// - Parameter event: The game event to handle.
    internal func handleGameEvent(_ event: GameEvent) {
        guard let engine = engine else { return }
        
        engine.process(event: event)
        
        onScoreChanged?(engine.currentScore)
        onLivesChanged?(engine.remainingLives)

        if engine.shouldResetBall {
            onBallResetNeeded?()
            engine.acknowledgeBallReset()
        }
    }

}
