import Testing
import SpriteKit

@testable import Breakout

struct SpriteKitNodeCreatorTest {

    @Test @MainActor func loadsDefaultLayoutWhenNoLayoutSpecified() throws {
        // This test will pass once we add default parameter
        let creator = SpriteKitNodeCreator()
        var bricksAdded: [(String, BrickColor)] = []

        let nodes = creator.createNodes { id, color in
            bricksAdded.append((id, color))
        }

        #expect(nodes[NodeNames.paddle] != nil)
        #expect(nodes[NodeNames.ball] != nil)
        #expect(nodes[NodeNames.brickLayout] != nil)
        #expect(bricksAdded.count > 0) // Should have loaded default layout
    }

    @Test @MainActor func loadsCustomLayoutWhenFileNameProvided() throws {
        // This test will pass once we add layoutFileName parameter
        let creator = SpriteKitNodeCreator(layoutFileName: "test-layout")
        var bricksAdded: [(String, BrickColor)] = []

        let nodes = creator.createNodes { id, color in
            bricksAdded.append((id, color))
        }

        // Should attempt to load "test-layout" (will fail since it doesn't exist)
        // But we need a way to verify it tried
        #expect(nodes[NodeNames.paddle] != nil)
        #expect(nodes[NodeNames.ball] != nil)
    }

    @Test @MainActor func usesInjectedLoaderToLoadLayout() throws {
        // This test will pass once we add layoutLoader parameter
        let mockLoader = MockBrickLayoutLoader()
        let creator = SpriteKitNodeCreator(
            layoutFileName: "custom-layout",
            layoutLoader: mockLoader
        )

        var bricksAdded: [(String, BrickColor)] = []
        let nodes = creator.createNodes { id, color in
            bricksAdded.append((id, color))
        }

        #expect(mockLoader.loadedFileName == "custom-layout")
        #expect(bricksAdded.count == 2) // MockLoader returns 2 bricks
        #expect(bricksAdded[0].1 == .red)
        #expect(bricksAdded[1].1 == .green)
    }

    @Test @MainActor func returnsEmptyLayoutWhenLoaderFails() throws {
        // This test will pass once we handle loader failures gracefully
        let failingLoader = FailingBrickLayoutLoader()
        let creator = SpriteKitNodeCreator(
            layoutFileName: "will-fail",
            layoutLoader: failingLoader
        )

        var bricksAdded: [(String, BrickColor)] = []
        let nodes = creator.createNodes { id, color in
            bricksAdded.append((id, color))
        }

        #expect(nodes[NodeNames.paddle] != nil) // Other nodes should still be created
        #expect(bricksAdded.count == 0) // No bricks loaded due to failure
    }
}

// MARK: - Test Doubles

class MockBrickLayoutLoader: BrickLayoutLoader {
    var loadedFileName: String?

    func load(fileName: String) throws -> BrickLayoutConfig {
        loadedFileName = fileName

        return BrickLayoutConfig(
            levelName: "Test Level",
            mapCols: 2,
            mapRows: 1,
            startX: 10,
            startY: 100,
            brickWidth: 20,
            brickHeight: 10,
            spacing: 3,
            rowSpacing: 12,
            brickTypes: [
                BrickTypeConfig(id: 1, colorName: "Red", scoreValue: 7),
                BrickTypeConfig(id: 2, colorName: "Green", scoreValue: 1)
            ],
            layout: [1, 2]
        )
    }
}

class FailingBrickLayoutLoader: BrickLayoutLoader {
    func load(fileName: String) throws -> BrickLayoutConfig {
        throw BrickLayoutLoaderError.fileNotFound(fileName)
    }
}
