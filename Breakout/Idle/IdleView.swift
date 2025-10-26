import Foundation
import SwiftUI

struct IdleViewWrapper: View {
    var body: some View {
        IdleView()
    }
}

struct IdleView: View {
    var body: some View {
        Text("Hello, world!")
    }
}

#Preview {
    IdleViewWrapper()
        .frame(width: 320 * 0.5, height: 480 * 0.5)
}
