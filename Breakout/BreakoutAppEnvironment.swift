import SwiftUI

private struct GameConfigurationKey: EnvironmentKey {
    static let defaultValue: GameConfiguration = .shared
}

extension EnvironmentValues {
    var gameConfiguration: GameConfiguration {
        get { self[GameConfigurationKey.self] }
        set { self[GameConfigurationKey.self] = newValue }
    }
}
