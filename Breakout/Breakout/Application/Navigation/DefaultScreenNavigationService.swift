import Foundation

@Observable
class DefaultScreenNavigationService: ScreenNavigationService {
    private let navigationState: NavigationState

    init(navigationState: NavigationState) {
        self.navigationState = navigationState
    }

    func navigate(to screen: Screen) {
        navigationState.currentScreen = screen
    }
}
