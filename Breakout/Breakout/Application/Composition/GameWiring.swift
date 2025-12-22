import Foundation

enum GameWiring {
    static func makeBrickService() -> BrickService {
        BrickService(adapter: JsonBrickLayoutAdapter())
    }
    
    static func makeCollisionRouter() -> DefaultCollisionRouter {
        DefaultCollisionRouter(
            brickIdentifier: NodeNameBrickIdentifier(),            
        )
    }
    
}
