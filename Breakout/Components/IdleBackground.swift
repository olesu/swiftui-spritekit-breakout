import SwiftUI

struct IdleBackground: View {
    var body: some View {
        Image("IdleScreenBackground")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}
