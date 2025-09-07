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
        SceneConfigurator.configureBackground(self)
        SceneConfigurator.configurePhysicsWorld(self)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: self.size))
        self.physicsBody?.categoryBitMask = PhysicsCategory.wall
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        self.physicsBody?.collisionBitMask = PhysicsCategory.ball
        
        setupPaddle()
        setupBall()
        setupBricks()
        updateForState()

        view.window?.acceptsMouseMovedEvents = true
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
                ballController.position = CGPoint(x: 0, y: 20)
            }
        }
    }
    
    func setupBricks() {
        for brick in gameService.bricks {
            let brickNode = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 20))
            brickNode.position = CGPoint(x: CGFloat.random(in: 50...350), y: CGFloat.random(in: 400...550))
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
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.zPosition = 10
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
