import Foundation

enum GameConfigurationError: Error, Equatable {
    case resourceNotFound(name: String, ext: String)
    case decodingFailed
}
