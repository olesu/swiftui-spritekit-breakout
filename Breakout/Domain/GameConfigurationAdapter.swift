import Foundation

/// Adapter for loading game configuration from external sources.
///
/// Abstracts the loading mechanism (JSON files, property lists, etc.)
/// from the domain layer. Implementations handle file I/O and deserialization.
internal protocol GameConfigurationAdapter {
    /// Loads the game configuration.
    /// - Returns: A decoded game configuration.
    /// - Throws: An error if the configuration cannot be loaded or decoded.
    func load() throws -> GameConfiguration
}
