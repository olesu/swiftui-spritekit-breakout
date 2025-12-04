internal enum CollisionCategory: UInt32 {
    case wall = 0b1         // 1
    case gutter = 0b10      // 2
    case ball = 0b100       // 4
    case brick = 0b1000     // 8
    case paddle = 0b10000   // 16
}

extension CollisionCategory {
    internal var mask: UInt32 {
        get {
            return self.rawValue
        }
    }
}
