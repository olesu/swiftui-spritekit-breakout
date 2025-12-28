import Foundation

@testable import Breakout

final class FakeSoundProducer: SoundProducer {
    var soundsPlayed: [SoundEffect] = []

    func play(_ soundEffect: SoundEffect) {
        soundsPlayed.append(soundEffect)
    }

}
