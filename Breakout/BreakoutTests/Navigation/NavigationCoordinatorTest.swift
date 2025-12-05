import Testing

@testable import Breakout

struct NavigationCoordinatorTest {

    @Test func startsOnIdleScreen() {
        let navigationState = NavigationState()
        navigationState.currentScreen = .idle
        let coordinator = NavigationCoordinator(
            navigationState: navigationState
        )

        #expect(coordinator.currentScreen == .idle)
    }

    @Test func startsOnGameScreen() {
        let navigationState = NavigationState()
        navigationState.currentScreen = .game
        let coordinator = NavigationCoordinator(
            navigationState: navigationState
        )

        #expect(coordinator.currentScreen == .game)
    }

    @Test func startsOnGameEndScreen() {
        let navigationState = NavigationState()
        navigationState.currentScreen = .gameEnd
        let coordinator = NavigationCoordinator(
            navigationState: navigationState
        )
        
        #expect(coordinator.currentScreen == .gameEnd)
    }

    @Test func updatesScreenWhenStateChangesToGame() {
        let navigationState = NavigationState()
        navigationState.currentScreen = .idle
        let coordinator = NavigationCoordinator(
            navigationState: navigationState
        )

        navigationState.currentScreen = .game

        #expect(coordinator.currentScreen == .game)
    }

    @Test func updatesScreenWhenStateChangesToIdle() {
        let navigationState = NavigationState()
        navigationState.currentScreen = .game
        let coordinator = NavigationCoordinator(
            navigationState: navigationState
        )

        navigationState.currentScreen = .idle

        #expect(coordinator.currentScreen == .idle)
    }
    
    @Test func updatesScreenWhenStateChangesToGameEnd() {
        let navigationState = NavigationState()
        navigationState.currentScreen = .game
        let coordinator = NavigationCoordinator(
            navigationState: navigationState
        )
        
        navigationState.currentScreen = .gameEnd
        
        #expect(coordinator.currentScreen == .gameEnd)
    }
}
