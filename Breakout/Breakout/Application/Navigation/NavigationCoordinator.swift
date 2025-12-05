import Foundation

@Observable final class NavigationCoordinator {
    private let navigationState: NavigationState

    internal init(navigationState: NavigationState) {
        self.navigationState = navigationState
    }

    var currentScreen: Screen {
        navigationState.currentScreen
    }
}
