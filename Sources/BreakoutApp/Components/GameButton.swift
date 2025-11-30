import SwiftUI

struct GameButton: View {
    let title: String
    let action: () -> Void
    let geometry: GeometryProxy

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: geometry.size.width * 0.08, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .cyan.opacity(0.9)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                .shadow(color: .cyan.opacity(0.8), radius: 8, x: 0, y: 0)
                .padding(.horizontal, geometry.size.width * 0.125)
                .padding(.vertical, geometry.size.height * 0.033)
                .background(
                    Capsule()
                        .fill(Color.blue)
                        .shadow(color: .blue.opacity(0.6), radius: 20, x: 0, y: 0)
                )
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
    }
}
