import Foundation
import SwiftUI

struct GameEndView: View {
    @State private var viewModel: GameEndViewModel

    init(screenNavigationService: ScreenNavigationService) {
        self._viewModel = State(initialValue: GameEndViewModel(
            screenNavigationService: screenNavigationService
        ))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("IdleScreenBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                VStack(spacing: geometry.size.height * 0.05) {
                    Text("GAME OVER")
                        .font(.system(size: geometry.size.width * 0.12, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .red.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .shadow(color: .red.opacity(0.6), radius: 8, x: 0, y: 0)

                    Button(action: {
                        Task {
                            await viewModel.playAgain()
                        }
                    }) {
                        Text("PLAY AGAIN")
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
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    GameEndView(screenNavigationService: PreviewScreenNavigationService())
        .frame(width: 320 * 0.5, height: 480 * 0.5)
}

private class PreviewScreenNavigationService: ScreenNavigationService {
    func navigate(to screen: Screen) {

    }
}
#endif
