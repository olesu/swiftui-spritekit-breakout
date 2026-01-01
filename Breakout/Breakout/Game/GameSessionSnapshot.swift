import Foundation

struct GameSessionSnapshot: Equatable {
    let score: Int
    let lives: Int
    let status: GameStatus
}
