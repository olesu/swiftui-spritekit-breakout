import Testing

@testable import Breakout

struct NavigationCoordinatorTest {

    @Test func startsOnIdleScreenWhenStateIsIdle() {
        let storage = InMemoryStorage()
        storage.state = .idle
        let coordinator = NavigationCoordinator(storage: storage)

        #expect(coordinator.currentScreen == .idle)
    }

    @Test func startsOnGameScreenWhenStateIsPlaying() {
        let storage = InMemoryStorage()
        storage.state = .playing
        let coordinator = NavigationCoordinator(storage: storage)

        #expect(coordinator.currentScreen == .game)
    }

    @Test func startsOnGameScreenWhenStateIsWon() {
        let storage = InMemoryStorage()
        storage.state = .won
        let coordinator = NavigationCoordinator(storage: storage)

        #expect(coordinator.currentScreen == .game)
    }

    @Test func startsOnGameScreenWhenStateIsGameOver() {
        let storage = InMemoryStorage()
        storage.state = .gameOver
        let coordinator = NavigationCoordinator(storage: storage)

        #expect(coordinator.currentScreen == .game)
    }

    @Test func updatesScreenWhenStateChangesToPlaying() {
        let storage = InMemoryStorage()
        storage.state = .idle
        let coordinator = NavigationCoordinator(storage: storage)

        storage.state = .playing

        #expect(coordinator.currentScreen == .game)
    }

    @Test func updatesScreenWhenStateChangesToIdle() {
        let storage = InMemoryStorage()
        storage.state = .playing
        let coordinator = NavigationCoordinator(storage: storage)

        storage.state = .idle

        #expect(coordinator.currentScreen == .idle)
    }
}
