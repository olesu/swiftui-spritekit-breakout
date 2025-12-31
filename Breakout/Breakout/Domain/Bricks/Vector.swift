import Foundation

struct Vector: Equatable {
    let dx: Double
    let dy: Double
}

extension Vector {
    static var zero: Vector { .init(dx: 0, dy: 0) }
}
