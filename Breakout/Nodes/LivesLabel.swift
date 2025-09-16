import SpriteKit

class LivesLabel: SKLabelNode {
    init(position: CGPoint) {
        super.init()
        self.text = "3"
        self.fontName = "Courier-Bold"
        self.fontSize = 20
        self.fontColor = .white
        self.position = position
        self.name = NodeNames.livesLabel.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
