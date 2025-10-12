import Foundation

protocol GameConfigurationLoader {
    func load() throws -> GameConfiguration
}
