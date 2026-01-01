/// Errors that can occur when loading brick layouts.
internal enum BrickLayoutAdapterError: Error {
    /// The specified layout file could not be found.
    case fileNotFound(String)
    /// The layout file contains invalid JSON or cannot be decoded.
    case invalidJson(String)
}
