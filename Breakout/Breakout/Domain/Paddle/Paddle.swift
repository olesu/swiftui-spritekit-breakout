struct Paddle {
    let position: Point
    let w: Double
    
    var halfWidth: Double { w / 2 }
    
    func with(position: Point) -> Paddle {
        .init(position: position, w: w)
    }
    
    func moveBy(amount dx: Double) -> Paddle {
        with(position: Point(x: position.x + dx, y: position.y))
    }
    
    func moveTo(_ position: Point) -> Paddle {
        with(position: position)
    }
}
