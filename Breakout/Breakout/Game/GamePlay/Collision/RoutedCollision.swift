enum RoutedCollision: Equatable {
    case ballHitBrick(BrickId: BrickId)
    case ballHitGutter
    case ballHitPaddle
    case none
}
