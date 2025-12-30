import Foundation

extension CGSize {
    init(_ size: Size) {
        self.init(
            width: CGFloat(size.width),
            height: CGFloat(size.height)
        )
    }
}

