import Foundation

/// Observable state for screen navigation.
@Observable public final class NavigationState {
    public init() {}
    
    public var currentScreen = Screen.idle
}
