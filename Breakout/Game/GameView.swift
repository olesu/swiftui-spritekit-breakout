import Foundation
import SpriteKit
import SwiftUI

struct GameViewWrapper: View {
    @Environment(GameConfigurationModel.self)
    private var configurationModel: GameConfigurationModel

    var body: some View {
        GameView(configurationModel: configurationModel)
    }
}

struct GameView: View {
    @State private var viewModel: GameViewModel
    @State private var scene: GameScene?

    init(configurationModel: GameConfigurationModel) {
        _viewModel = State(
            initialValue: GameViewModel(configurationModel: configurationModel)
        )
    }

    var body: some View {
        VStack {
            if let scene = scene {
                SpriteView(scene: scene)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                NotificationCenter.default.post(
                                    name: .paddlePositionChanged,
                                    object: nil,
                                    userInfo: ["location": value.location]
                                )
                            }
                    )
            }
        }
        .onAppear {
            if scene == nil {
                // Create nodes and collect bricks
                var bricks = Bricks()
                let nodeCreator = SpriteKitNodeCreator()
                let nodes = nodeCreator.createNodes { brickId, nsColor in
                    let color = BrickColor(from: nsColor) ?? .green
                    bricks.add(Brick(id: BrickId(of: brickId), color: color))
                }

                // Initialize engine with collected bricks
                viewModel.initializeEngine(with: bricks)

                // Create scene
                let gameScene = GameScene(
                    size: viewModel.sceneSize,
                    brickArea: viewModel.brickArea,
                    nodes: nodes,
                    onGameEvent: { [viewModel] event in
                        viewModel.handleGameEvent(event)
                    }
                )

                // Wire up ViewModel callbacks to Scene update methods
                viewModel.onScoreChanged = { [weak gameScene] score in
                    gameScene?.updateScore(score)
                }
                viewModel.onLivesChanged = { [weak gameScene] lives in
                    gameScene?.updateLives(lives)
                }

                scene = gameScene
            }
        }
    }
}

#Preview {
    let configurationModel = GameConfigurationModel(service: PreviewGameConfigurationService())
    GameViewWrapper()
        .environment(configurationModel)
        .frame(
            width: configurationModel.frameWidth,
            height: configurationModel.frameHeight
        )
}

class PreviewGameConfigurationService: GameConfigurationService {
    func getGameConfiguration() -> GameConfiguration {
        GameConfiguration(
            sceneWidth: 320,
            sceneHeight: 480,
            brickArea: BrickArea(
                x: 20,
                y: 330,
                width: 280,
                height: 120
            )
        )
    }

    func getGameScale() -> CGFloat {
        0.5
    }
    
}

