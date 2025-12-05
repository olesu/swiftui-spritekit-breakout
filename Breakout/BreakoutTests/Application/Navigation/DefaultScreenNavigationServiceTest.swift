import Testing
@testable import Breakout

@MainActor
struct DefaultScreenNavigationServiceTests {

    @Test
    func navigationServiceUpdatesState() {
        let state = NavigationState()
        state.currentScreen = .idle
        let service = DefaultScreenNavigationService(navigationState: state)

        service.navigate(to: .game)
        #expect(state.currentScreen == .game)

        service.navigate(to: .gameEnd)
        #expect(state.currentScreen == .gameEnd)
    }
}
