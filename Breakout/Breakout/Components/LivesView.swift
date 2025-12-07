import SwiftUI

struct LivesView: View {
    let lives: Int

    var body: some View {
        Text("❤️ \(lives)")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.white)
    }
}
