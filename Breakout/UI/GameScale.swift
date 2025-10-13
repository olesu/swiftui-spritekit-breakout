import SwiftUI

private struct GameScaleKey: EnvironmentKey {
    static let defaultValue = 2.0
}

extension EnvironmentValues {
    var gameScale: CGFloat {
        get { self[GameScaleKey.self] }
        set { self[GameScaleKey.self] = newValue }
    }
}
