import SwiftUI

struct LivesView: View {
    let lives: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<lives, id: \.self) { _ in
                Text("❤️")
                    .font(.system(size: 28))
            }
        }
    }
}
