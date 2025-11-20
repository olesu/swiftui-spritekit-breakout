import Foundation

@Observable internal final class NavigationCoordinator {
    private let storage: InMemoryStorage

    internal init(storage: InMemoryStorage) {
        self.storage = storage
    }

    internal var currentScreen: Screen {
        Self.determineScreen(from: storage.state)
    }

    private static func determineScreen(from state: GameState) -> Screen {
        switch state {
        case .idle:
            return .idle
        case .playing, .won, .gameOver:
            return .game
        }
    }

    internal enum Screen {
        case idle
        case game
    }
}
