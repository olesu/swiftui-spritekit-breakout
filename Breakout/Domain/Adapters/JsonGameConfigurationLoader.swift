import Foundation

internal final class JsonGameConfigurationLoader: GameConfigurationLoader {
    internal enum LoaderError: Error {
        case resourceNotFound(String, String)
        case decodingFailed(Error)
    }

    internal func load() throws -> GameConfiguration {
        let resourceName = "GameConfiguration"
        let resourceExt = "json"

        guard
            let url = Bundle.main.url(
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
