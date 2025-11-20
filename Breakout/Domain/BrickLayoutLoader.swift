import Foundation

internal enum BrickLayoutLoaderError: Error {
    case fileNotFound(String)
    case invalidJson(String)
}

internal protocol BrickLayoutLoader {
    func load(fileName: String) throws -> BrickLayoutConfig
}
