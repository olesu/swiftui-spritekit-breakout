import Foundation

internal protocol GameConfigurationAdapter {
    func load() throws -> GameConfiguration
}
