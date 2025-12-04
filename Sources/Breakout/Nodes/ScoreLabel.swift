import SpriteKit

internal final class ScoreLabel: SKLabelNode {
    internal init(position: CGPoint) {
        super.init()
        self.text = "00"
        self.fontName = "Courier-Bold"
        self.fontSize = 20
        self.fontColor = .white
        self.position = position
        self.name = NodeNames.scoreLabel.rawValue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
