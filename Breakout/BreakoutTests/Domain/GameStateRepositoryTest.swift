import Foundation
import Testing

@testable import Breakout

@MainActor
struct GameStateRepositoryTest {
    private let initial = GameState.initial(startingLives: 3)
    
    @Test func testSaveAndLoad_persistsGameState() {
        let repository = InMemoryGameStateRepository()
        let state = initial
            .with(score: 100)
            .with(lives: 2)
            .with(status: .playing)

        repository.save(state)
        let loadedState = repository.load()

        #expect(loadedState == state)
    }

    @Test func testLoad_whenNoStateSaved_returnsInitialState() {
        let repository = InMemoryGameStateRepository(initialState: initial)

        let loadedState = repository.load()

        #expect(loadedState == initial)
    }

    @Test func testSave_overwritesPreviousState() {
        let repository = InMemoryGameStateRepository()
        let state1 = initial.with(score: 50)
        let state2 = initial.with(score: 100)

        repository.save(state1)
        repository.save(state2)
        let loadedState = repository.load()

        #expect(loadedState == state2)
        #expect(loadedState.score == 100)
    }
}
