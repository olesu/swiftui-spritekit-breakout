import SpriteKit

protocol CollisionRouter {
    func route(_ collision : Collision) -> RoutedCollision
}
