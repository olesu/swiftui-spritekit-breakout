import Foundation

struct Size: Equatable, Codable {
    let width: Double
    let height: Double
}

extension Size {
    static var zero: Self { .init(width: 0, height: 0) }
}
