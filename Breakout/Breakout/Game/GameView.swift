import Foundation
import SpriteKit
import SwiftUI

struct GameView: View {
    @Environment(GameViewModel.self) private var viewModel: GameViewModel
    @State private var scene: GameScene?
    @FocusState private var isFocused: Bool

    private let sceneBuilder: GameSceneBuilder

    init(sceneBuilder: GameSceneBuilder) {
        self.sceneBuilder = sceneBuilder
    }

    var body: some View {
        ZStack {
            VStack {
                if let scene = scene {
                    SpriteView(
                        scene: scene,
                        debugOptions: [ /*.showsPhysics,*/
                            .showsFPS, .showsNodeCount,
                        ]
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
                            scene.pressLeft()
                            return .handled
                        }
                        .onKeyPress(.rightArrow) {
                            scene.pressRight()
                            return .handled
                        }
                        .onKeyPress(keys: [.leftArrow], phases: .up) { _ in
                            scene.releaseLeft()
                            return .handled
                        }
                        .onKeyPress(keys: [.rightArrow], phases: .up) { _ in
                            scene.releaseRight()
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
                viewModel.startNewGame()
                scene = sceneBuilder.makeScene()
            }
            .task {
                isFocused = true
            }

            VStack {
                HStack {
                    ScoreView(score: viewModel.currentScore)
                    Spacer()
                    LivesView(lives: viewModel.remainingLives)
                }
                .padding()
                Spacer()
            }
        }
    }

}
