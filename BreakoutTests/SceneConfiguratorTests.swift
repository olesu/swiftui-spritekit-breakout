import XCTest

class SceneConfiguratorTests: XCTestCase {
    func testPhysicsWorldGravityConfiguration() {
        // Given
        let sceneConfigurator = SceneConfigurator()
        let expectedGravity = CGVector(dx: 0.0, dy: -9.8)

        // When
        sceneConfigurator.configurePhysicsWorld()

        // Then
        XCTAssertNotEqual(sceneConfigurator.physicsWorld.gravity, expectedGravity, "Gravity should be configured to the expected value, but it isn't.")
    }
}