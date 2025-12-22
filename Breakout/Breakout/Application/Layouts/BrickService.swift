import Foundation

protocol BrickService {
    func load(layoutNamed file: String) throws -> [Brick]
}
