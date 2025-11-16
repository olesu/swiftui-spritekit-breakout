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
                                scene.movePaddle(to: value.location)
                            }
                    )
            }
        }
        .onAppear {
            if scene == nil {
                scene = setupGame()
            }
        }
    }

    private func setupGame() -> GameScene {
        let (nodes, bricks) = createNodesAndCollectBricks()
        initializeEngine(with: bricks)
        return createScene(with: nodes)
    }

    private func createNodesAndCollectBricks() -> ([NodeNames: SKNode], Bricks) {
        var bricks = Bricks()
        let nodeCreator = SpriteKitNodeCreator()
        let nodes = nodeCreator.createNodes { brickId, nsColor in
            let color = BrickColor(from: nsColor) ?? .green
            bricks.add(Brick(id: BrickId(of: brickId), color: color))
        }
        return (nodes, bricks)
    }

    private func initializeEngine(with bricks: Bricks) {
        viewModel.initializeEngine(with: bricks)
    }

    private func createScene(with nodes: [NodeNames: SKNode]) -> GameScene {
        let gameScene = GameScene(
            size: viewModel.sceneSize,
            brickArea: viewModel.brickArea,
            nodes: nodes,
            onGameEvent: { [viewModel] event in
                viewModel.handleGameEvent(event)
            }
        )

        // Wire up ViewModel callbacks to Scene
        viewModel.onScoreChanged = { [weak gameScene] score in
            gameScene?.updateScore(score)
        }
        viewModel.onLivesChanged = { [weak gameScene] lives in
            gameScene?.updateLives(lives)
        }

        return gameScene
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

