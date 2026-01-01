import Foundation

struct AppConfiguration {
    private static let defaults = UserDefaults.standard

    static func startingLevelPolicy(
        default defaultPolicy: StartingLevelPolicy = .production
    ) -> StartingLevelPolicy {
        let raw = defaults.string(
            forKey: AppConfigurationKeys.startingLevelPolicy
        )

        return raw.flatMap(StartingLevelPolicy.init) ?? defaultPolicy
    }
}
