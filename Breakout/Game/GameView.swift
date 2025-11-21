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
    var viewModel: GameViewModel
    @State private var scene: GameScene?

    init(configurationModel: GameConfigurationModel) {
        self.viewModel = GameViewModel(configurationModel: configurationModel)
    }

    var body: some View {
        VStack {
            if let scene = scene {
                SpriteView(scene: scene, debugOptions: [.showsPhysics, .showsFPS, .showsNodeCount])
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
        let nodes = nodeCreator.createNodes { brickId, brickColor in
            bricks.add(Brick(id: BrickId(of: brickId), color: brickColor))
        }
        return (nodes, bricks)
    }

    private func initializeEngine(with bricks: Bricks) {
        viewModel.initializeEngine(with: bricks)
    }

    private func createScene(with nodes: [NodeNames: SKNode]) -> GameScene {
        let viewModel = self.viewModel
        let gameScene = GameScene(
            size: viewModel.sceneSize,
            nodes: nodes,
            onGameEvent: { [weak viewModel] event in
                viewModel?.handleGameEvent(event)
            }
        )

        setupCallbacks(in: viewModel, using: gameScene)

        return gameScene
    }
    
    private func setupCallbacks(in viewModel: GameViewModel, using scene: GameScene) {
        viewModel.onScoreChanged = { [weak scene] score in
            scene?.updateScore(score)
        }
        viewModel.onLivesChanged = { [weak scene] lives in
            scene?.updateLives(lives)
        }
        viewModel.onBallResetNeeded = { [weak scene] in
            scene?.resetBall()
        }
    }
}

#if DEBUG
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

#endif
