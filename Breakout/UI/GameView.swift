import Foundation
import SwiftUI
import SpriteKit

struct GameView: View {
    // External source-of-truth value for preferences
    var initialAutoPaddleConfig: AutoPaddleConfig

    @State private var scoreCard = ScoreCard()
    @State private var livesCard = LivesCard(3)
    @State private var scene: BreakoutScene
    @State private var autoPaddleConfig: AutoPaddleConfig
    @State private var bricks: Bricks

    init(initialAutoPaddleConfig: AutoPaddleConfig) {
        self.initialAutoPaddleConfig = initialAutoPaddleConfig
        _autoPaddleConfig = State(initialValue: initialAutoPaddleConfig)

        // Collect bricks during scene creation without capturing self
        var collectedBricks = Bricks()
        let initialScene = BreakoutScene(autoPaddleConfig: initialAutoPaddleConfig, onBrickAdded: { brickName in
            collectedBricks.add(Brick(id: BrickId(of: brickName)))
        })

        _scene = State(initialValue: initialScene)
        _bricks = State(initialValue: collectedBricks)
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: 320, height: 480)
            .onAppear {
                scene.scaleMode = .aspectFit
                scene.backgroundColor = .black

                scene.onBrickRemoved = {
                    DispatchQueue.main.async {
                        // Increment by 1 each time a brick is removed
                        scoreCard.score(1)
                        // Update the in-scene HUD label
                        scene.updateScoreLabel(to: scoreCard.total)
                    }
                }

                // Initialize HUD with current score and lives
                scene.updateScoreLabel(to: scoreCard.total)
                scene.updateLivesLabel(to: livesCard.remaining)

                scene.onBallMissed = {
                    DispatchQueue.main.async {
                        // Decrement remaining lives and update HUD
                        livesCard.lifeWasLost()
                        scene.updateLivesLabel(to: livesCard.remaining)
                    }
                }
            }
            .onChange(of: autoPaddleConfig) { _, newValue in
                scene.apply(autoPaddleConfig: newValue)
            }
            .onChange(of: initialAutoPaddleConfig) { _, newValue in
                // Keep internal state in sync with app-level preferences
                autoPaddleConfig = newValue
                scene.apply(autoPaddleConfig: newValue)
            }
    }
}

#Preview {
    GameView(initialAutoPaddleConfig: AutoPaddleConfig())
}
