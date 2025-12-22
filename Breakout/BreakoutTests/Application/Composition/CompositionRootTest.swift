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

    private func startNewGameAndYieldToLetObservationFire(
        _ deps: RootDependencies
    ) async throws {
        try deps.gameViewModel.startNewGame()
        await Task.yield()
    }

}
