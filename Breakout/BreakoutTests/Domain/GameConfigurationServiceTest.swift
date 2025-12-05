import Testing
import Foundation

@testable import Breakout

extension GameConfiguration {
    static func createValid() -> GameConfiguration {
        GameConfiguration(
            sceneWidth: 0,
            sceneHeight: 0,
            brickArea: BrickArea(
                x: 10,
                y: 20,
                width: 30,
                height: 40
            )
        )
    }
}

struct GameConfigurationServiceTest {

    @Test func getsTheGameConfiguration() {
        let loader = FakeGameConfigurationAdapter()
        let service = RealGameConfigurationService(loader: loader)
        let configuration = service.getGameConfiguration()

        #expect(configuration == GameConfiguration.createValid())
    }

    @Test func providesFallbackConfigurationWhenLoaderFails() {
        let loader = FailingGameConfigurationAdapter()
        let service = RealGameConfigurationService(loader: loader)
        let configuration = service.getGameConfiguration()

        #expect(configuration.sceneWidth == 320)
        #expect(configuration.sceneHeight == 480)
        #expect(configuration.brickArea.width > 0)
    }

}

class FakeGameConfigurationAdapter: GameConfigurationAdapter {
    func load() throws -> GameConfiguration {
        GameConfiguration.createValid()
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
