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
            view: view,
            delegate: self,
        )
        
        setupBottomWall()
        setupPaddle()
        setupBall()
        setupBricks()
        updateForState()
    }
    
    func setupBottomWall() {
        addChild(BottomWallController(worldSize: size))
    }
    
    func setupPaddle() {
        paddleController = PaddleController(gameAreaWidth: size.width)
        addChild(paddleController!)
    }
    
    func setupBall() {
        guard let paddle = paddleController else { return }
        
        ballController = BallController(paddlePosition: paddle.position)
        ballController!.position = CGPoint(x: 0, y: GameConstants.ballOffset)

        paddle.addChild(ballController!)
    }
    
    func setupBricks() {
        gameService.bricks
            .map(createBrick)
            .forEach(addChild)
    }
    
    private func createBrick(for brick: Brick) -> SKSpriteNode {
        let brickNode = SKSpriteNode(color: .red, size: GameConstants.brickSize)
        brickNode.position = CGPoint(
            x: CGFloat.random(in: GameConstants.brickXRange),
            y: CGFloat.random(in: GameConstants.brickYRange),
        )
        brickNode.name = brick.id.uuidString
        
        return brickNode
    }
    
    func updateForState() {
        stateLabel?.removeFromParent()
        handleGameStateChange(gameService.state)
    }
    
    private func handleGameStateChange(_ newState: GameState) {
        switch newState {
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
        guard gameService.state == .ready else { return }
        
        let clickLocation = event.location(in: self)
        launchBall(toward: clickLocation)
        gameService.launchBall()
        handleGameStateChange(gameService.state)
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

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask
        
        if (categoryA == PhysicsCategory.ball && categoryB == PhysicsCategory.bottomWall) ||
            (categoryA == PhysicsCategory.bottomWall && categoryB == PhysicsCategory.ball) {
            ballHitBottom()
        }
    }
}
