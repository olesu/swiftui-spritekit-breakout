import Foundation

protocol GameConfigurationDataSource {
    func data(forResource name: String, withExtension ext: String) throws -> Data
}

