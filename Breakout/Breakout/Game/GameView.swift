import Foundation
import SpriteKit
import SwiftUI

struct GameView: View {
    @Environment(GameViewModel.self) private var viewModel: GameViewModel
    @State private var scene: GameScene?
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            if let scene = scene {
                SpriteView(
                    scene: scene,
                    debugOptions: [/*.showsPhysics,*/ .showsFPS, .showsNodeCount]
                )
                .focusable()
                .focused($isFocused)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            scene.movePaddle(to: value.location)
                        }
                        .onEnded { _ in
                            scene.endPaddleOverride()
                        }
                )
                #if os(macOS)
                .onKeyPress(.leftArrow) {
                    scene.startMovingPaddleLeft()
                    return .handled
                }
                .onKeyPress(.rightArrow) {
                    scene.startMovingPaddleRight()
                    return .handled
                }
                .onKeyPress(keys: [.leftArrow, .rightArrow], phases: .up) { _ in
                    scene.stopMovingPaddle()
                    return .handled
                }
                .onKeyPress(.space) {
                    scene.launchBall()
                    return .handled
                }
                #endif
            }
        }
        .onAppear {
                setupGame()
        }
        .task {
            try? await Task.sleep(for: .milliseconds(100))
            isFocused = true
        }
    }

    private func setupGame() {
        viewModel.onSceneNodesCreated = onSceneNodesCreated
        viewModel.startNewGame()
    }
    
    private func onSceneNodesCreated(_ nodes: [NodeNames: SKNode]) {
        scene = createScene(with: nodes)
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
        scene.onBallResetComplete = { [weak viewModel] in
            viewModel?.acknowledgeBallReset()
        }
    }
}

