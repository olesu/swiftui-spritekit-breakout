import Foundation

final class JsonBrickLayoutLoader: BrickLayoutLoader {
    func load(fileName: String) throws -> BrickLayoutConfig {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw BrickLayoutLoaderError.fileNotFound(fileName)
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(BrickLayoutConfig.self, from: data)
        } catch {
            throw BrickLayoutLoaderError.invalidJson(fileName)
        }
    }
}
