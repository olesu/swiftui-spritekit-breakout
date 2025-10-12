import Foundation

class JsonGameConfigurationLoader : GameConfigurationLoader {
    func load() throws -> GameConfiguration {
        let resourceName = "GameConfiguration"
        let resourceExt = "json"

        guard
            let url = Bundle.main.url(
                forResource: resourceName,
                withExtension: resourceExt
            )
        else {
            fatalError("Could not find \(resourceName).\(resourceExt) file.")
        }

        do {
            let data = try Data(contentsOf: url)
            let config = try JSONDecoder().decode(
                GameConfiguration.self,
                from: data
            )
            return config
        } catch {
            print("Failed to decode GameConfiguration: \(error)")
            fatalError("Could not load \(resourceName).\(resourceExt)!")
        }

    }
}
