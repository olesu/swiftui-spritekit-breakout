import Foundation

/// Errors that can occur when loading brick layouts.
internal enum BrickLayoutAdapterError: Error {
    /// The specified layout file could not be found.
    case fileNotFound(String)
    /// The layout file contains invalid JSON or cannot be decoded.
    case invalidJson(String)
}

/// Adapter for loading brick layout configurations from external sources.
///
/// Abstracts the loading mechanism (JSON files, network, etc.) from
/// the domain layer. Implementations handle file I/O and deserialization.
internal protocol BrickLayoutAdapter {
    /// Loads a brick layout configuration from the specified file.
    /// - Parameter fileName: The name of the layout file to load (without extension).
    /// - Returns: A decoded brick layout configuration.
    /// - Throws: `BrickLayoutAdapterError` if the file is not found or contains invalid data.
    func load(fileName: String) throws -> BrickLayoutConfig
}
