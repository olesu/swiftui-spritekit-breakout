import Foundation

protocol BrickLayoutLoader {
    func load(fileName: String) throws -> BrickLayoutConfig
}

final class JsonBrickLayoutLoader: BrickLayoutLoader {
    func load(fileName: String) throws -> BrickLayoutConfig {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            fatalError("Missing file")
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(BrickLayoutConfig.self, from: data)
    }
}
