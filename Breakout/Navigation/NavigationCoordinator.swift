import Foundation

@Observable class NavigationCoordinator {
    private let storage: InMemoryStorage

    init(storage: InMemoryStorage) {
        self.storage = storage
    }

    var currentScreen: Screen {
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

    enum Screen {
        case idle
        case game
    }
}
