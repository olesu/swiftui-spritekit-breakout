import Foundation

internal enum BrickLayoutAdapterError: Error {
    case fileNotFound(String)
    case invalidJson(String)
}

internal protocol BrickLayoutAdapter {
    func load(fileName: String) throws -> BrickLayoutConfig
}
