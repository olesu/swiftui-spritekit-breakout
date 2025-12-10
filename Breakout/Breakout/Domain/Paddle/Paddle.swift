struct Paddle {
    let x: Double
    let w: Double
    
    var halfWidth: Double { w / 2 }
    
    func with(x: Double) -> Paddle {
        .init(x: x, w: w)
    }
    
    func moveBy(amount dx: Double) -> Paddle {
        with(x: x + dx)
    }
    
    func moveTo(_ x: Double) -> Paddle {
        with(x: x)
    }
}
