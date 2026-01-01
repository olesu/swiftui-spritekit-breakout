import Testing
import Foundation

@testable import Breakout

struct ApplicationComposerTest {

    @Test func rootCreatesPlayableGameViewModel() throws {
        let loader = GameConfigurationLoader(
            gameConfigurationAdapter: FakeGameConfigurationAdapter()
        )
        let deps = try ApplicationComposer.compose(
            brickService: FakeBrickService(),
            startingLevel: StartingLevel(layoutFileName: "some-level"),
            gameConfigurationLoader: loader
        )

        deps.gameViewModel.startNewGame()

        #expect(deps.gameViewModel.gameStatus != .idle)
    }

    @Test func rootUsesDevStartingLevelWhenConfigured() throws {
        let loader = GameConfigurationLoader(
            gameConfigurationAdapter: FakeGameConfigurationAdapter()
        )
        let brickService = FakeBrickService()
        let deps = try ApplicationComposer.compose(
            brickService: brickService,
            startingLevel: GameWiring.makeStartingLevel(policy: .dev),
            gameConfigurationLoader: loader
        )

        deps.gameViewModel.startNewGame()

        #expect(
            brickService.loadedLayoutName == GameWiring.devStartingLevelLayout
        )
    }

}
