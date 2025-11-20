import Foundation

internal protocol GameConfigurationLoader {
    func load() throws -> GameConfiguration
}
