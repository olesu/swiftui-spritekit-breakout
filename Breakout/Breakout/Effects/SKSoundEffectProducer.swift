import Foundation
import SpriteKit

final class SKSoundEffectProducer: SoundEffectProducer {
    private weak var parentNode: SKNode?
    private var audioNodes: [SoundEffect: SKAudioNode] = [:]

    func attach(to parentNode: SKNode) {
        self.parentNode = parentNode
        preloadSounds()
    }

    private func preloadSounds() {
        guard let parentNode else { return }

        for sound in SoundEffect.allCases {
            let node = SKAudioNode(fileNamed: sound.fileName)
            node.autoplayLooped = false
            node.isPositional = false
            parentNode.addChild(node)
            audioNodes[sound] = node
        }
    }

    // TODO: Sounds seem to be playing in sequence, so it takes a long time to finish when hitting multiple bricks
    func play(_ soundEffect: SoundEffect) {
        audioNodes[soundEffect]?.run(.play())
    }
}
