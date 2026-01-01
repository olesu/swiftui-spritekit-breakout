// In your SpriteKit / UI / Infrastructure module, NOT in Domain
import AppKit

extension BrickColor {
    init?(nsColor: NSColor) {
        let color = nsColor.usingColorSpace(.deviceRGB) ?? nsColor
        let r = color.redComponent
        let g = color.greenComponent
        let b = color.blueComponent

        // Tolerance for floating-point comparison
        let tolerance: CGFloat = 0.05

        func close(_ a: CGFloat, _ b: CGFloat) -> Bool {
            abs(a - b) <= tolerance
        }

        switch true {
        case close(r, 1) && close(g, 0) && close(b, 0):
            self = .red
        case close(r, 1) && close(g, 0.5) && close(b, 0):
            self = .orange
        case close(r, 1) && close(g, 1) && close(b, 0):
            self = .yellow
        case close(r, 0) && close(g, 1) && close(b, 0):
            self = .green
        default:
            return nil
        }
    }
}

extension BrickColor {
    func toNSColor() -> NSColor {
        switch self {
        case .red:
            return NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        case .orange:
            return NSColor(red: 1, green: 0.5, blue: 0, alpha: 1)
        case .yellow:
            return NSColor(red: 1, green: 1, blue: 0, alpha: 1)
        case .green:
            return NSColor(red: 0, green: 1, blue: 0, alpha: 1)
        }
    }
}
