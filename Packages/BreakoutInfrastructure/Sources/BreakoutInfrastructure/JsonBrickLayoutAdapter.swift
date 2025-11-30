import Foundation
import BreakoutDomain

public final class JsonBrickLayoutAdapter: BrickLayoutAdapter {
    private let bundle: Bundle

    public init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    public func load(fileName: String) throws -> BrickLayoutConfig {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
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
