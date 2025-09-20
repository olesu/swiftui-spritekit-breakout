enum CollisionCategory: UInt32 {
    case ball = 0b100       // 4
    case brick = 0b1000     // 8
    case paddle = 0b10000   // 16
}

extension CollisionCategory {
    var mask: UInt32 {
        get {
            return self.rawValue
        }
    }
}
