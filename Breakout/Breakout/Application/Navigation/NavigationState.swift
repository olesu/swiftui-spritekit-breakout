import Foundation

/// Observable state for screen navigation.
@Observable internal final class NavigationState {
    internal var currentScreen = Screen.idle
}
