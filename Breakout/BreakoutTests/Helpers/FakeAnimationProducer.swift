import Foundation

@testable import Breakout

final class FakeVisualEffectProducer: VisualEffectProducer {
    var visualEffectsPlayed: [VisualEffect] = []

    func play(_ visualEffect: VisualEffect) {
        visualEffectsPlayed.append(visualEffect)
    }
}
