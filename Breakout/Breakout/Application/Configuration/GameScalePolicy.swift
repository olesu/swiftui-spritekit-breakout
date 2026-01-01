import Foundation

struct GameScalePolicy {
    let scale: CGFloat

    static var deviceScale: GameScalePolicy {
        #if os(macOS)
            return .init(scale: 1.5)
        #else
            return UIDevice.current.userInterfaceIdiom == .pad
                ? .init(scale: 3.0) : .init(scale: 2.0)
        #endif
    }

    #if DEBUG
    static var preview: GameScalePolicy {
        .init(scale: 0.5)
    }
    #endif
}
