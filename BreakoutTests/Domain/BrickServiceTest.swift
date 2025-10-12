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
        let service = GameConfigurationService(loader: loader)
        let configuration = service.getGameConfiguration()

        #expect(configuration == GameConfiguration.createValid())
    }

}

class FakeGameConfigurationLoader: GameConfigurationLoader {
    func load() throws -> GameConfiguration {
        GameConfiguration.createValid()
    }

}
