import Foundation
import SpriteKit

final class SKSoundEffectProducer: SoundEffectProducer {
    private weak var parentNode: SKNode?
    private var soundActions: [SoundEffect: SKAction] = [:]

    func attach(to parentNode: SKNode) {
        self.parentNode = parentNode
        preloadSounds()
    }

    private func preloadSounds() {
        for sound in SoundEffect.allCases {
            let action = SKAction.playSoundFileNamed(sound.fileName, waitForCompletion: false)
            soundActions[sound] = action
        }
    }

    func play(_ soundEffect: SoundEffect) {
        guard let action = soundActions[soundEffect] else { return }

        parentNode?.run(action)
    }
}
