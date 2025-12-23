import Testing
import Foundation

@testable import Breakout

@MainActor
struct ApplicationComposerTest {

    @Test func rootCreatesPlayableGameViewModel() async throws {
        let loader = GameConfigurationLoader(
            gameConfigurationAdapter: FakeGameConfigurationAdapter()
        )
        let deps = try ApplicationComposer.compose(
            brickService: FakeBrickService(),
            startingLevel: StartingLevel(layoutFileName: "some-level"),
            gameConfigurationLoader: loader
        )

        try await startNewGameAndYieldToLetObservationFire(deps)

        #expect(deps.gameViewModel.gameStatus != .idle)
    }

    @Test func rootUsesDevStartingLevelWhenConfigured() async throws {
        let loader = GameConfigurationLoader(
            gameConfigurationAdapter: FakeGameConfigurationAdapter()
        )
        let brickService = FakeBrickService()
        let deps = try ApplicationComposer.compose(
            brickService: brickService,
            startingLevel: GameWiring.makeStartingLevel(policy: .dev),
            gameConfigurationLoader: loader
        )

        try await startNewGameAndYieldToLetObservationFire(deps)

        #expect(
            brickService.loadedLayoutName == GameWiring.devStartingLevelLayout
        )
    }

    private func startNewGameAndYieldToLetObservationFire(
        _ context: AppContext
    ) async throws {
        try context.gameViewModel.startNewGame()
        await Task.yield()
    }

}
