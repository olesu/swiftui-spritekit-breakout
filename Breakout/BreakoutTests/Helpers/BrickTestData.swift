import Foundation

@testable import Breakout

extension BrickId {
    static func createValid(id: String = "1") -> BrickId {
        .init(of: id)
    }
}

extension Brick {
    static func createValid(brickId: BrickId = BrickId.createValid()) -> Brick {
        .init(id: brickId, color: .red, position: Point.zero)
    }
}
