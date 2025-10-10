import Foundation

struct GameConfiguration: Codable, Equatable {
    let sceneWidth: CGFloat
    let sceneHeight: CGFloat
    
    static let shared: GameConfiguration = {
        guard let url = Bundle.main.url(forResource: "GameConfiguration", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let config = try? PropertyListDecoder().decode(GameConfiguration.self, from: data) else {
            fatalError("Could not load GameConfiguration.plist!")
        }
        return config
    }()

}
