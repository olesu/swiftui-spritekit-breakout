@testable import Breakout

struct FakeGameConfigurationAdapter: GameConfigurationAdapter {
    func load() throws -> GameConfiguration {
        GameConfiguration.defaultValue()
    }
}
