import Foundation

final class JsonBrickLayoutAdapter: BrickLayoutAdapter {
    func load(fileName: String) throws -> BrickLayoutConfig {
        guard
            let url = Bundle.main.url(
                forResource: fileName,
                withExtension: "json"
            )
        else {
            throw BrickLayoutAdapterError.fileNotFound(fileName)
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(BrickLayoutConfig.self, from: data)
        } catch {
            throw BrickLayoutAdapterError.invalidJson(fileName)
        }
    }
}
