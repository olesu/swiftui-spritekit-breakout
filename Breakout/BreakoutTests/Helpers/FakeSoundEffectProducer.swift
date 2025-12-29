import Foundation

@testable import Breakout

final class FakeSoundEffectProducer: SoundEffectProducer {
    var soundEffectsPlayed: [SoundEffect] = []

    func play(_ soundEffect: SoundEffect) {
        soundEffectsPlayed.append(soundEffect)
    }

}
