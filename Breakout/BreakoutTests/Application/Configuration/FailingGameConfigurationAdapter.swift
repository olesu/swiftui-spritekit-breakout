@testable import Breakout

struct FailingGameConfigurationAdapter: GameConfigurationAdapter {
    enum LoadError: Error {
        case configurationNotFound
    }

    func load() throws -> GameConfiguration {
        throw LoadError.configurationNotFound
    }
}
