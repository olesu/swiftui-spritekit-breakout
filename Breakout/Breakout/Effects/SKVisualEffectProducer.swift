import Foundation
import SpriteKit

final class SKVisualEffectProducer: VisualEffectProducer {
    private let nodeManager: NodeManager
    private weak var effectsNode: SKNode?
    
    init(nodeManager: NodeManager) {
        self.nodeManager = nodeManager
    }

    func attach(to effectsNode: SKNode) {
        self.effectsNode = effectsNode
    }

    func play(_ visualEffect: VisualEffect) {
        switch visualEffect {
        case .brickHit:
            playBrickHitEffect()
        }
    }

    private func playBrickHitEffect() {
        guard let effectsNode else { return }
        guard let position = nodeManager.lastBrickHitPosition else { return }

        let flash = SKShapeNode(rectOf: CGSize(width: 24, height: 12))
        flash.fillColor = .white
        flash.strokeColor = .clear
        flash.alpha = 0.8
        flash.zPosition = 1000

        flash.position = position

        effectsNode.addChild(flash)

        let scaleUp = SKAction.scale(to: 1.4, duration: 0.05)
        let fadeOut = SKAction.fadeOut(withDuration: 0.08)
        let remove = SKAction.removeFromParent()

        flash.run(.sequence([
            .group([scaleUp, fadeOut]),
            remove
        ]))
    }
}
