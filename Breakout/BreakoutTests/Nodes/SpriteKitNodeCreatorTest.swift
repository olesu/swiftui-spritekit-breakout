import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct SpriteKitNodeCreatorTest {
    private let loader = LoadBrickLayoutService(
        adapter: JsonBrickLayoutAdapter()
    )

    @Test func loadsDefaultLayoutWhenNoLayoutSpecified() throws {
        // This test will pass once we add default parameter
        let creator = SpriteKitNodeCreator(layoutLoader: loader)
        var bricksAdded: [(String, BrickColor)] = []

        let nodes = creator.createNodes { brick in
            bricksAdded.append((brick.id.value, brick.color))
        }

        #expect(nodes[NodeNames.paddle] != nil)
        #expect(nodes[NodeNames.ball] != nil)
        #expect(nodes[NodeNames.brickLayout] != nil)
        #expect(bricksAdded.count > 0)  // Should have loaded default layout
    }

    @Test func loadsCustomLayoutWhenFileNameProvided() throws {
        // This test will pass once we add layoutFileName parameter
        let creator = SpriteKitNodeCreator(
            layoutFileName: "test-layout",
            layoutLoader: loader
        )
        var bricksAdded: [(String, BrickColor)] = []

        let nodes = creator.createNodes { brick in
            bricksAdded.append((brick.id.value, brick.color))
        }

        // Should attempt to load "test-layout" (will fail since it doesn't exist)
        // But we need a way to verify it tried
        #expect(nodes[NodeNames.paddle] != nil)
        #expect(nodes[NodeNames.ball] != nil)
    }

    @Test func usesInjectedLoaderToLoadLayout() throws {
        let mockAdapter = MockBrickLayoutAdapter()
        let mockLoader = LoadBrickLayoutService(
            adapter: mockAdapter
        )
        let creator = SpriteKitNodeCreator(
            layoutFileName: "custom-layout",
            layoutLoader: mockLoader
        )

        var bricksAdded: [(String, BrickColor)] = []
        let _ = creator.createNodes { brick in
            bricksAdded.append((brick.id.value, brick.color))
        }

        #expect(mockAdapter.loadedFileName == "custom-layout")
        #expect(bricksAdded.count == 2)  // MockLoader returns 2 bricks
        #expect(bricksAdded[0].1 == .red)
        #expect(bricksAdded[1].1 == .green)
    }

    @Test func returnsEmptyLayoutWhenLoaderFails() throws {
        // This test will pass once we handle loader failures gracefully
        let adapter = FailingBrickLayoutAdapter()
        let loader = LoadBrickLayoutService(adapter: adapter)
        let creator = SpriteKitNodeCreator(
            layoutFileName: "will-fail",
            layoutLoader: loader
        )

        var bricksAdded: [(String, BrickColor)] = []
        let nodes = creator.createNodes { brick in
            bricksAdded.append((brick.id.value, brick.color))
        }

        #expect(nodes[NodeNames.paddle] != nil)  // Other nodes should still be created
        #expect(bricksAdded.count == 0)  // No bricks loaded due to failure
    }
}

// MARK: - Test Doubles

class MockBrickLayoutAdapter: BrickLayoutAdapter {
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
                BrickTypeConfig(id: 2, colorName: "Green", scoreValue: 1),
            ],
            layout: [1, 2]
        )
    }
}

class FailingBrickLayoutAdapter: BrickLayoutAdapter {
    func load(fileName: String) throws -> BrickLayoutConfig {
        throw BrickLayoutAdapterError.fileNotFound(fileName)
    }
}
