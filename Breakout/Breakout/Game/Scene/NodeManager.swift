import SpriteKit

protocol NodeManager {
    var paddle: SKSpriteNode { get }
    var ball: SKSpriteNode { get }
    var bricks: SKNode { get }
    
    var topWall: SKSpriteNode { get }
    var leftWall: SKSpriteNode { get }
    var rightWall: SKSpriteNode { get }
    var gutter: SKSpriteNode { get }
    
    func remove(brickId: BrickId)
}
