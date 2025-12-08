struct Point: Equatable {
    let x: Double
    let y: Double
    
    static var zero: Point  {
        .init(x: 0, y: 0)
    }
}
