import Foundation

/// Observable state for screen navigation.
@Observable final class NavigationState {
    internal var currentScreen = Screen.idle
}
