import Foundation

/// Service for managing screen navigation transitions.
protocol ScreenNavigationService {
    /// Navigates to the specified screen.
    /// - Parameter screen: The screen to navigate to.
    func navigate(to screen: Screen)
}
