import Testing

@testable import Breakout

@MainActor
struct CompositionRootTest {

    @Test func rootCreatesPlayableGameViewModel() async throws {
        let deps = CompositionRoot.makeRootDependencies(
            brickService: FakeBrickService(),
            startingLevel: StartingLevel(layoutFileName: "some-level")
        )

        try await startNewGameAndYieldToLetObservationFire(deps)

        #expect(deps.gameViewModel.gameStatus != .idle)
    }

    @Test func rootUsesDevStartingLevelWhenConfigured() async throws {
        let brickService = FakeBrickService()
        let deps = CompositionRoot.makeRootDependencies(
            brickService: brickService,
            startingLevel: GameWiring.makeStartingLevel(policy: .dev)
        )

        try await startNewGameAndYieldToLetObservationFire(deps)

        #expect(
            brickService.loadedLayoutName == GameWiring.devStartingLevelLayout
        )
    }

    private func startNewGameAndYieldToLetObservationFire(
        _ deps: RootDependencies
    ) async throws {
        try deps.gameViewModel.startNewGame()
        await Task.yield()
    }

}
