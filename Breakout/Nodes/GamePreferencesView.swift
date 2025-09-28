import SwiftUI

struct GamePreferencesView: View {
    @Binding var autoPaddleConfig: AutoPaddleConfig

    var body: some View {
        TabView {
            AutoPaddleControlsTab(config: $autoPaddleConfig)
                .tabItem {
                    Label("Controls", systemImage: "slider.horizontal.3")
                }
        }
        .frame(width: 420)
        .padding()
    }
}

struct AutoPaddleControlsTab: View {
    @Binding var config: AutoPaddleConfig

    var body: some View {
        Form {
            Section("Auto Paddle") {
                // Paddle Speed
                HStack {
                    Text("Paddle Speed")
                    Spacer()
                    Text(String(format: "%.0f", config.paddleSpeed))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                Slider(value: $config.paddleSpeed, in: 100...1200, step: 10)

                // Horizontal Jitter Range
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Jitter Range X")
                        Spacer()
                        Text(String(format: "%.0f…%.0f", config.jitterRangeX.lowerBound, config.jitterRangeX.upperBound))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    HStack(spacing: 12) {
                        // Lower bound
                        VStack(alignment: .leading) {
                            Text("Min")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Slider(value: Binding(
                                get: { config.jitterRangeX.lowerBound },
                                set: { config.jitterRangeX = $0...max($0, config.jitterRangeX.upperBound) }
                            ), in: -60...0, step: 1)
                        }
                        // Upper bound
                        VStack(alignment: .leading) {
                            Text("Max")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Slider(value: Binding(
                                get: { config.jitterRangeX.upperBound },
                                set: {
                                    let newValue = max(0, $0)
                                    if newValue >= config.jitterRangeX.lowerBound {
                                        config.jitterRangeX = config.jitterRangeX.lowerBound...newValue
                                    } else {
                                        config.jitterRangeX = config.jitterRangeX.lowerBound...config.jitterRangeX.lowerBound
                                    }
                                }
                            ), in: 0...60, step: 1)
                        }
                    }
                }

                // Reaction Time Range
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Reaction Time (s)")
                        Spacer()
                        Text(String(format: "%.2f…%.2f", config.reactionTimeRange.lowerBound, config.reactionTimeRange.upperBound))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    HStack(spacing: 12) {
                        // Lower bound
                        VStack(alignment: .leading) {
                            Text("Min")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Slider(value: Binding(
                                get: { config.reactionTimeRange.lowerBound },
                                set: { config.reactionTimeRange = $0...max($0, config.reactionTimeRange.upperBound) }
                            ), in: 0.0...0.5, step: 0.01)
                        }
                        // Upper bound
                        VStack(alignment: .leading) {
                            Text("Max")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Slider(value: Binding(
                                get: { config.reactionTimeRange.upperBound },
                                set: {
                                    let newValue = max(0.0, $0)
                                    if newValue >= config.reactionTimeRange.lowerBound {
                                        config.reactionTimeRange = config.reactionTimeRange.lowerBound...newValue
                                    } else {
                                        config.reactionTimeRange = config.reactionTimeRange.lowerBound...config.reactionTimeRange.lowerBound
                                    }
                                }
                            ), in: 0.0...1.0, step: 0.01)
                        }
                    }
                }

                // Skip Move Probability
                HStack {
                    Text("Skip Move Probability")
                    Spacer()
                    Text(String(format: "%.0f%%", config.skipMoveProbability * 100))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                Slider(value: $config.skipMoveProbability, in: 0.0...0.5, step: 0.01)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    @Previewable @State var cfg = AutoPaddleConfig()
    GamePreferencesView(autoPaddleConfig: $cfg)
        .frame(width: 480)
}
