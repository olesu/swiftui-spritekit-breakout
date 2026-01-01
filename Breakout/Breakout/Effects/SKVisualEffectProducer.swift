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
            playBrickHitFlashEffect()
            playBrickHitShardEffect()
        }
    }
}

// MARK: Brick Hit Flash
extension SKVisualEffectProducer {
    private func playBrickHitFlashEffect() {
        guard let effectsNode else { return }
        guard let position = nodeManager.lastBrickHitPosition else { return }

        let flash = makeBrickHitFlash(at: position)
        effectsNode.addChild(flash)

        flash.run(brickHitAction())
    }

    private func makeBrickHitFlash(at position: CGPoint) -> SKShapeNode {
        let flash = SKShapeNode(rectOf: BrickHitTuning.size)
        flash.fillColor = .white
        flash.strokeColor = .clear
        flash.alpha = 0.8
        flash.zPosition = 1000

        flash.position = position

        return flash
    }

    private func brickHitAction() -> SKAction {
        let scaleUp = SKAction.scale(
            to: BrickHitTuning.scale,
            duration: BrickHitTuning.scaleDuration
        )
        let fadeOut = SKAction.fadeOut(
            withDuration: BrickHitTuning.fadeDuration
        )
        let remove = SKAction.removeFromParent()

        return .sequence([
            .group([scaleUp, fadeOut]),
            remove
        ])
    }

    private enum BrickHitTuning {
        static let size = CGSize(width: 24, height: 12)
        static let scale = CGFloat(1.4)
        static let scaleDuration = TimeInterval(0.05)
        static let fadeDuration = TimeInterval(0.08)
    }

}

// MARK: Brick Hit Shards
extension SKVisualEffectProducer {
    private func playBrickHitShardEffect() {
        guard let effectsNode else { return }
        guard let emitter = SKEmitterNode(fileNamed: "BrickHitShards") else {
            return
        }
        guard let position = nodeManager.lastBrickHitPosition else { return }

        emitter.position = position
        emitter.numParticlesToEmit = 8
        effectsNode.addChild(emitter)

        emitter.run(.sequence([.wait(forDuration: 1.0), .removeFromParent()]))
    }
}
