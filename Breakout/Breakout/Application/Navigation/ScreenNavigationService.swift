import Foundation

/// Service for managing screen navigation transitions.
protocol ScreenNavigationService {
    /// Navigates to the specified screen.
    /// - Parameter screen: The screen to navigate to.
    func navigate(to screen: Screen)
}

@Observable
nonisolated class RealScreenNavigationService: ScreenNavigationService {
    private let navigationState: NavigationState

    internal init(navigationState: NavigationState) {
        self.navigationState = navigationState
    }

    internal func navigate(to screen: Screen) {
        navigationState.currentScreen = screen
    }
}
