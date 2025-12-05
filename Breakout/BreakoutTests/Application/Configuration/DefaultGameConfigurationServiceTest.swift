import Foundation
import Testing

@testable import Breakout

@MainActor
struct GameConfigurationServiceTest {

    @Test func returnsGameConfigurationFromAdapter() {
        let service = DefaultGameConfigurationService(
            gameConfigurationAdapter: FakeGameConfigurationAdapter()
        )
        let configuration = service.getGameConfiguration()

        #expect(configuration == GameConfiguration.defaultValue())
    }

    @Test func returnsFallbackConfigurationWhenAdapterThrows() {
        let service = DefaultGameConfigurationService(
            gameConfigurationAdapter: FailingGameConfigurationAdapter()
        )
        let configuration = service.getGameConfiguration()

        #expect(configuration == GameConfiguration.defaultValue())
    }

}

