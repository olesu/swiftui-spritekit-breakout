import Foundation

struct GameConfiguration: Codable, Equatable {
    let sceneWidth: CGFloat
    let sceneHeight: CGFloat
    
    static let shared: GameConfiguration = {
        let resourceName = "GameConfiguration"
        let resourceExt = "plist"
        
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: resourceExt),
              let data = try? Data(contentsOf: url),
              let config = try? PropertyListDecoder().decode(GameConfiguration.self, from: data) else {
            fatalError("Could not load \(resourceName).\(resourceExt)!")
        }
        return config
    }()

}
