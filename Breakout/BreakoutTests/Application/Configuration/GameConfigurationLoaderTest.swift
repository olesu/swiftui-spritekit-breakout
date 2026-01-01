import Foundation
import Testing

@testable import Breakout

struct GameConfigurationLoaderTest {

    @Test func returnsGameConfigurationFromAdapter() throws {
        let loader = GameConfigurationLoader(
            gameConfigurationAdapter: FakeGameConfigurationAdapter()
        )
        let configuration = try loader.load()

        #expect(configuration == GameConfiguration.defaultValue())
    }

    @Test func loadThrowsWhenAdapterThrows() throws {
        let loader = GameConfigurationLoader(
            gameConfigurationAdapter: FailingGameConfigurationAdapter()
        )
        #expect(throws: Error.self) {
            try loader.load()
        }
    }
    
    @Test func bundledGameConfigurationDecodes() throws {
        let loader = GameConfigurationLoader(
            gameConfigurationAdapter: JsonGameConfigurationAdapter(bundle: .main)
        )
        
        _ = try loader.load()
        
    }

}

