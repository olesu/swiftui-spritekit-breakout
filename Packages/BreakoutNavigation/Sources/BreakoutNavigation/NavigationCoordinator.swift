import Foundation

@Observable public final class NavigationCoordinator {
    private let navigationState: NavigationState

    public init(navigationState: NavigationState) {
        self.navigationState = navigationState
    }

    public var currentScreen: Screen {
        navigationState.currentScreen
    }
}
