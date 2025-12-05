import Foundation

@Observable internal final class NavigationCoordinator {
    private let navigationState: NavigationState

    internal init(navigationState: NavigationState) {
        self.navigationState = navigationState
    }

    internal var currentScreen: Screen {
        navigationState.currentScreen
    }
}
