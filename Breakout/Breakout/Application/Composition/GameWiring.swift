import Foundation

enum GameWiring {
    static func makeStartingLevel() -> StartingLevel {
        .init(layoutFileName: "001-classic-breakout")
    }
    
    static func makeBrickService() -> LayoutLoadingBrickService {
        LayoutLoadingBrickService(adapter: JsonBrickLayoutAdapter())
    }
    
    static func makeCollisionRouter() -> DefaultCollisionRouter {
        DefaultCollisionRouter(
            brickIdentifier: NodeNameBrickIdentifier(),            
        )
    }
    
}
