import SwiftUI

struct ScoreView: View {
    private let score: Int

    public init(score: Int) {
        self.score = score
    }

    var body: some View {
        Text(String(format: "%02d", score))
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.white)
    }
}
