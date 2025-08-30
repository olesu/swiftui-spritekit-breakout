import Foundation

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let ball: UInt32 = 0b1 // 1
    static let paddle: UInt32 = 0b10 // 2
    static let brick: UInt32 = 0b100  // 4
    static let wall: UInt32 = 0b1000  // 8
}
