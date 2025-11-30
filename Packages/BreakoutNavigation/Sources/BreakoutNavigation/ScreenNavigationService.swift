import Foundation

/// Service for managing screen navigation transitions.
public protocol ScreenNavigationService {
    /// Navigates to the specified screen.
    /// - Parameter screen: The screen to navigate to.
    func navigate(to screen: Screen)
}

public struct RealScreenNavigationService: ScreenNavigationService {
    private let navigationState: NavigationState

    public init(navigationState: NavigationState) {
        self.navigationState = navigationState
    }

    public func navigate(to screen: Screen) {
        navigationState.currentScreen = screen
    }
}
