import Foundation
import SpriteKit
import SwiftUI

struct GameView: View {
    @Environment(GameViewModel.self) private var viewModel: GameViewModel
    
    @State private var scene: GameScene?
    @State private var paddleXPosition: CGFloat = 0
    @State private var isMovingLeft = false
    @State private var isMovingRight = false
    @State private var movementTimer: Timer?
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
                            paddleXPosition = value.location.x
                            scene.movePaddle(to: value.location)
                        }
                )
                #if os(macOS)
                .onKeyPress(.leftArrow) {
                    isMovingLeft = true
                    return .handled
                }
                .onKeyPress(.rightArrow) {
                    isMovingRight = true
                    return .handled
                }
                .onKeyPress(keys: [.leftArrow, .rightArrow], phases: .up) { press in
                    if press.key == .leftArrow {
                        isMovingLeft = false
                    } else if press.key == .rightArrow {
                        isMovingRight = false
                    }
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
            if scene == nil {
                scene = setupGame()
                paddleXPosition = viewModel.sceneSize.width / 2
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(100))
            isFocused = true
        }
        #if os(macOS)
        .onChange(of: isMovingLeft) { _, _ in
            updatePaddleMovement()
        }
        .onChange(of: isMovingRight) { _, _ in
            updatePaddleMovement()
        }
        #endif
    }

    #if os(macOS)
    private func updatePaddleMovement() {
        guard let scene = scene else { return }

        movementTimer?.invalidate()

        if isMovingLeft || isMovingRight {
            movementTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [self] timer in
                let paddleSpeed: CGFloat = 8.0
                if isMovingLeft {
                    paddleXPosition = max(0, paddleXPosition - paddleSpeed)
                }
                if isMovingRight {
                    paddleXPosition = min(viewModel.sceneSize.width, paddleXPosition + paddleSpeed)
                }

                scene.movePaddle(to: CGPoint(x: paddleXPosition, y: 0))
            }
        }
    }
    #endif

    private func setupGame() -> GameScene {
        let (nodes, bricks) = createNodesAndCollectBricks()
        viewModel.initializeBricks(bricks)
        viewModel.resetGame()
        viewModel.startGame()
        return createScene(with: nodes)
    }

    private func createNodesAndCollectBricks() -> ([NodeNames: SKNode], [BrickId: Brick])
    {
        var bricks: [BrickId: Brick] = [:]
        let nodeCreator = SpriteKitNodeCreator()
        let nodes = nodeCreator.createNodes { brickId, brickColor in
            let brick = Brick(id: BrickId(of: brickId), color: brickColor)
            bricks[brick.id] = brick
        }
        return (nodes, bricks)
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

