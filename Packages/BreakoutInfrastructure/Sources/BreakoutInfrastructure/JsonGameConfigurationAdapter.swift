import Foundation
import BreakoutDomain

public final class JsonGameConfigurationAdapter: GameConfigurationAdapter {
    private let bundle: Bundle

    public init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    public enum LoaderError: Error {
        case resourceNotFound(String, String)
        case decodingFailed(Error)
    }

    public func load() throws -> GameConfiguration {
        let resourceName = "GameConfiguration"
        let resourceExt = "json"

        guard
            let url = bundle.url(
                forResource: resourceName,
                withExtension: resourceExt
            )
        else {
            throw LoaderError.resourceNotFound(resourceName, resourceExt)
        }

        do {
            let data = try Data(contentsOf: url)
            let config = try JSONDecoder().decode(
                GameConfiguration.self,
                from: data
            )
            return config
        } catch {
            throw LoaderError.decodingFailed(error)
        }

    }
}
