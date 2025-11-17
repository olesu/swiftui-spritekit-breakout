import Foundation

enum BrickLayoutLoaderError: Error {
    case fileNotFound(String)
    case invalidJson(String)
}

protocol BrickLayoutLoader {
    func load(fileName: String) throws -> BrickLayoutConfig
}
