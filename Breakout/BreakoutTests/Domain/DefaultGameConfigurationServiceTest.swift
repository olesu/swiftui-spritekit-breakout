import Testing
import Foundation

@testable import Breakout

struct GameConfigurationServiceTest {

    @Test func getsTheGameConfiguration() {
        let loader = FakeGameConfigurationAdapter()
        let service = DefaultGameConfigurationService(loader: loader)
        let configuration = service.getGameConfiguration()

        #expect(configuration == GameConfiguration.defaultValue())
    }

    @Test func providesFallbackConfigurationWhenLoaderFails() {
        let loader = FailingGameConfigurationAdapter()
        let service = DefaultGameConfigurationService(loader: loader)
        let configuration = service.getGameConfiguration()
        
        #expect(configuration == GameConfiguration.defaultValue())

        #expect(configuration.sceneWidth == 320)
        #expect(configuration.sceneHeight == 480)
        #expect(configuration.brickArea.width > 0)
    }

}

class FakeGameConfigurationAdapter: GameConfigurationAdapter {
    func load() throws -> GameConfiguration {
        GameConfiguration.defaultValue()
    }
}

class FailingGameConfigurationAdapter: GameConfigurationAdapter {
    enum LoadError: Error {
        case configurationNotFound
    }

    func load() throws -> GameConfiguration {
        throw LoadError.configurationNotFound
    }
}
