import Foundation

@testable import Breakout

extension Brick {
    static func createValid() -> Brick {
        .init(id: BrickId(of: "1"), color: .red, position: Point.zero)
    }
}
