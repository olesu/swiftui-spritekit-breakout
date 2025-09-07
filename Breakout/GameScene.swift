//
//  GameScene.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 26/08/2025.
//

import SpriteKit

class GameScene: SKScene {
    var gameService: GameService
    
    private var stateLabel: SKLabelNode?
    private var paddleController: PaddleController?
    private var ballController: BallController?
    
    init(gameService: GameService, size: CGSize) {
        self.gameService = gameService
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        SceneConfigurator.configureScene(
            self,
            bounds: CGRect(origin: .zero, size: self.size),
            view: view)
        
        setupPaddle()
        setupBall()
        setupBricks()
        updateForState()
    }
    
    func setupPaddle() {
        paddleController = PaddleController(gameAreaWidth: size.width)
        if let paddleController = paddleController {
            addChild(paddleController)
        }
    }
    
    func setupBall() {
        if let paddleController = paddleController {
            ballController = BallController(paddlePosition: paddleController.position)
            if let ballController = ballController {
                paddleController.addChild(ballController)
                ballController.position = CGPoint(x: 0, y: GameConstants.ballOffset)
            }
        }
    }
    
    func setupBricks() {
        for brick in gameService.bricks {
            let brickNode = SKSpriteNode(color: .red, size: GameConstants.brickSize)
            brickNode.position = CGPoint(
                x: CGFloat.random(in: GameConstants.brickXRange),
                y: CGFloat.random(in: GameConstants.brickYRange),
            )
            brickNode.name = brick.id.uuidString
            addChild(brickNode)
        }
    }
    
    func updateForState() {
        stateLabel?.removeFromParent()
        
        switch gameService.state {
        case .ready:
            showOverlay(text: "Tap to start")
        case .playing:
            break
        case .gameOver:
            showOverlay(text: "Game Over")
        case .won:
            showOverlay(text: "You won!")
        }
    }
    
    func showOverlay(text: String) {
        let label = SKLabelNode(text: text)
        label.fontName = "AvenirNext-Bold"
        label.fontSize = GameConstants.overlayFontSize
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.zPosition = GameConstants.overlayZPosition
        addChild(label)
        stateLabel = label
    }
    
    override func mouseDown(with event: NSEvent) {
        if gameService.state == .ready {
            let clickLocation = event.location(in: self)
            launchBall(toward: clickLocation)
            gameService.launchBall()
            updateForState()
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        let location = event.location(in: self)
        paddleController?.moveTo(x: location.x)
    }
    
    func brickHit(_ brick: Brick) {
        gameService.ballHitBrick(brick)
        if let node = childNode(withName: brick.id.uuidString) as? SKSpriteNode {
            node.removeFromParent()
        }
        updateForState()
    }
    
    func ballHitBottom() {
        gameService.ballHitBottom()
        updateForState()
    }
    
    func launchBall(toward target: CGPoint) {
        if let ballController = ballController {
            ballController.launch(to: self, toward: target)
        }
    }
}
