import Foundation

protocol BrickService {
    func loadBundle(named file: String, levels: [LevelId]) throws -> LevelBundle
}
