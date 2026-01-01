struct Paddle {
    let position: Point
    let width: Double

    var halfWidth: Double { width / 2 }

    func with(position: Point) -> Paddle {
        .init(position: position, width: width)
    }

    func moveBy(amount dx: Double) -> Paddle {
        with(position: Point(x: position.x + dx, y: position.y))
    }

    func moveTo(_ position: Point) -> Paddle {
        with(position: position)
    }
}
