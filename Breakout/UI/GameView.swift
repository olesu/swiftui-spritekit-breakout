import Foundation
import SpriteKit
import SwiftUI

struct GameView: View {
    // External source-of-truth value for preferences
    var initialAutoPaddleConfig: AutoPaddleConfig

    @Environment(\.gameConfiguration) private var gameConfiguration

    @State private var scoreCard = ScoreCard()
    @State private var livesCard = LivesCard(3)
    @State private var scene: BreakoutScene?
    @State private var autoPaddleConfig: AutoPaddleConfig
    @State private var bricks: Bricks?

    init(initialAutoPaddleConfig: AutoPaddleConfig) {
        self.initialAutoPaddleConfig = initialAutoPaddleConfig
        _autoPaddleConfig = State(initialValue: initialAutoPaddleConfig)
    }

    var body: some View {
        Group {
            if let scene = scene {
                SpriteView(scene: scene)
                    .frame(width: 320, height: 480)
                    .onAppear {
                        scene.scaleMode = .aspectFit
                        scene.backgroundColor = .black

                        scene.onBrickRemoved = {
                            DispatchQueue.main.async {
                                scoreCard.score(1)
                                scene.updateScoreLabel(to: scoreCard.total)
                            }
                        }

                        scene.updateScoreLabel(to: scoreCard.total)
                        scene.updateLivesLabel(to: livesCard.remaining)

                        scene.onBallMissed = {
                            DispatchQueue.main.async {
                                livesCard.lifeWasLost()
                                scene.updateLivesLabel(to: livesCard.remaining)
                            }
                        }
                    }
                    .onChange(of: autoPaddleConfig) { _, newValue in
                        scene.apply(autoPaddleConfig: newValue)
                    }
                    .onChange(of: initialAutoPaddleConfig) { _, newValue in
                        autoPaddleConfig = newValue
                        scene.apply(autoPaddleConfig: newValue)
                    }
            } else {
                Color.clear
                    .frame(width: 320, height: 480)
                    .onAppear {
                        var collectedBricks = Bricks()
                        let newScene = BreakoutScene(
                            gameSize: CGSize(width: gameConfiguration.sceneWidth, height: gameConfiguration.sceneHeight),
                            autoPaddleConfig: initialAutoPaddleConfig,
                            onBrickAdded: { brickName in
                                collectedBricks.add(Brick(id: BrickId(of: brickName)))
                            }
                        )
                        scene = newScene
                        bricks = collectedBricks
                    }
            }
        }
    }
}

#Preview {
    GameView(initialAutoPaddleConfig: AutoPaddleConfig())
}
