import Testing
import Foundation

@testable import Breakout

struct BrickLayoutAdapterTest {

    @Test func loadsValidJsonFile() throws {
        let loader = JsonBrickLayoutAdapter()

        let config = try loader.load(fileName: "001-classic-breakout")

        #expect(config.levelName == "Classic Breakout Level 1")
        #expect(config.mapCols == 14)
        #expect(config.mapRows == 8)
    }

    @Test func throwsErrorForMissingFile() {
        let loader = JsonBrickLayoutAdapter()

        #expect(throws: BrickLayoutAdapterError.self) {
            try loader.load(fileName: "nonexistent-file")
        }
    }

    @Test func throwsErrorForInvalidJson() {
        let loader = JsonBrickLayoutAdapter()

        #expect(throws: BrickLayoutAdapterError.self) {
            try loader.load(fileName: "invalid-json")
        }
    }
}
