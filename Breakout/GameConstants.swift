import CoreGraphics

struct GameConstants {
    static let brickSize = CGSize(width: 50, height: 20)
    static let brickXRange: ClosedRange<CGFloat> = 50...350
    static let brickYRange: ClosedRange<CGFloat> = 400...550
    static let ballOffset: CGFloat = 10
    static let overlayZPosition: CGFloat = 10
    static let overlayFontSize: CGFloat = 40
}
