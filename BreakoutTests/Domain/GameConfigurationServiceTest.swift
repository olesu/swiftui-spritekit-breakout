import Testing

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

    @Test func getsTheGameConfiguration() async throws {
        let loader = FakeGameConfigurationLoader()
        let service = RealGameConfigurationService(loader: loader)
        let configuration = service.getGameConfiguration()

        #expect(configuration == GameConfiguration.createValid())
    }

    @Test func providesFallbackConfigurationWhenLoaderFails() async throws {
        let loader = FailingGameConfigurationLoader()
        let service = RealGameConfigurationService(loader: loader)
        let configuration = service.getGameConfiguration()

        #expect(configuration.sceneWidth == 320)
        #expect(configuration.sceneHeight == 480)
        #expect(configuration.brickArea.width > 0)
    }

}

class FakeGameConfigurationLoader: GameConfigurationLoader {
    func load() throws -> GameConfiguration {
        GameConfiguration.createValid()
    }
}

class FailingGameConfigurationLoader: GameConfigurationLoader {
    enum LoadError: Error {
        case configurationNotFound
    }

    func load() throws -> GameConfiguration {
        throw LoadError.configurationNotFound
    }
}
