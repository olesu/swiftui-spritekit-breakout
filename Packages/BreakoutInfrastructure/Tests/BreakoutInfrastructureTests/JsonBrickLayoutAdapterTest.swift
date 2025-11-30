import BreakoutDomain
import Foundation
import Testing

@testable import BreakoutInfrastructure

struct JsonBrickLayoutAdapterTest {
    private let brickLayoutAdapter = JsonBrickLayoutAdapter(bundle: .module)

    @Test func loadsValidJsonFile() throws {
        let config = try brickLayoutAdapter.load(fileName: "001-classic-breakout")

        #expect(config.levelName == "Classic Breakout Level 1")
        #expect(config.mapCols == 14)
        #expect(config.mapRows == 8)
    }

    @Test func throwsErrorForMissingFile() {
        #expect(throws: BrickLayoutAdapterError.fileNotFound("nonexistent-file")) {
            try brickLayoutAdapter.load(fileName: "nonexistent-file")
        }
    }

    @Test func throwsErrorForInvalidJson() {
        #expect(throws: BrickLayoutAdapterError.invalidJson("invalid-json")) {
            try brickLayoutAdapter.load(fileName: "invalid-json")
        }
    }
}
