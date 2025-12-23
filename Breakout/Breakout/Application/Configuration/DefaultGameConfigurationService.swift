import Foundation

final class GameConfigurationLoader {
    private let gameConfigurationAdapter: GameConfigurationAdapter

    init(gameConfigurationAdapter: GameConfigurationAdapter) {
        self.gameConfigurationAdapter = gameConfigurationAdapter
    }

    func load() throws -> GameConfiguration {
        try gameConfigurationAdapter.load()
    }

}
