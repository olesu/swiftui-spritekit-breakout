struct Paddle {
    let x: Double
    let y: Double
    let w: Double
    let h: Double
    
    var halfWidth: Double { w / 2 }
    
    func with(x: Double) -> Paddle {
        .init(x: x, y: y, w: w, h: h)
    }
    
    func moveBy(amount dx: Double) -> Paddle {
        with(x: x + dx)
    }
    
    func moveTo(_ x: Double) -> Paddle {
        with(x: x)
    }
}
