import Foundation

enum GameWiring {
    static let productionStartingLevelLayout = "001-classic-breakout"
    static let devStartingLevelLayout = "dev-single-brick"

    static func makeStartingLevel(policy: StartingLevelPolicy) -> StartingLevel
    {
        switch policy {
        case .production:
            .init(layoutFileName: productionStartingLevelLayout)
        case .dev:
            .init(layoutFileName: devStartingLevelLayout)
        }
    }

    static func makeBrickService() -> BrickService {
        LayoutLoadingBrickService(adapter: JsonBrickLayoutAdapter())
    }

    static func makeCollisionRouter() -> DefaultCollisionRouter {
        DefaultCollisionRouter(
            brickIdentifier: NodeNameBrickIdentifier(),
        )
    }

    static func makeGameConfigurationLoader(bundle: Bundle = .main)
        -> GameConfigurationLoader
    {
        GameConfigurationLoader(
            gameConfigurationAdapter: JsonGameConfigurationAdapter(
                bundle: bundle
            )
        )
    }

}
