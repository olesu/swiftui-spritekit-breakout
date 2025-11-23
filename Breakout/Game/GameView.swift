import Foundation
import SpriteKit
import SwiftUI

struct GameView: View {
    private let viewModel: GameViewModel
    private let storage: InMemoryStorage
    @State private var scene: GameScene?

    init(
        configurationService: GameConfigurationService,
        screenNavigationService: ScreenNavigationService,
        storage: InMemoryStorage,
        gameResultService: GameResultService
    ) {
        self.storage = storage
        self.viewModel = GameViewModel(
            configurationService: configurationService,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService
        )
    }

    var body: some View {
        VStack {
            if let scene = scene {
                SpriteView(
                    scene: scene,
                    debugOptions: [.showsPhysics, .showsFPS, .showsNodeCount]
                )
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
        let engine = createEngine(with: bricks)
        viewModel.setEngine(engine)
        engine.start()
        return createScene(with: nodes)
    }

    private func createNodesAndCollectBricks() -> ([NodeNames: SKNode], Bricks)
    {
        var bricks = Bricks()
        let nodeCreator = SpriteKitNodeCreator()
        let nodes = nodeCreator.createNodes { brickId, brickColor in
            bricks.add(Brick(id: BrickId(of: brickId), color: brickColor))
        }
        return (nodes, bricks)
    }

    private func createEngine(with bricks: Bricks) -> GameEngine {
        let adapter = InMemoryGameStateAdapter(storage: storage)
        return BreakoutGameEngine(bricks: bricks, stateAdapter: adapter)
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

        wireCallbacks(from: viewModel, to: gameScene)

        return gameScene
    }

    private func wireCallbacks(
        from viewModel: GameViewModel,
        to scene: GameScene
    ) {
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
        let configurationService = PreviewGameConfigurationService()
        let screenNavigationService = RealScreenNavigationService(
            navigationState: NavigationState()
        )
        let storage = InMemoryStorage()
        let gameResultAdapter = InMemoryGameResultAdapter(storage: storage)
        let gameResultService = RealGameResultService(adapter: gameResultAdapter)
        GameView(
            configurationService: configurationService,
            screenNavigationService: screenNavigationService,
            storage: storage,
            gameResultService: gameResultService
        )
        .frame(
            width: configurationService.getGameConfiguration().sceneWidth
                * configurationService.getGameScale(),
            height: configurationService.getGameConfiguration().sceneHeight
                * configurationService.getGameScale()
        )
    }

    private class PreviewGameConfigurationService: GameConfigurationService {
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
