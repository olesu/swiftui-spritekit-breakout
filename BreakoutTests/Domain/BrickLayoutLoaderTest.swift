import Testing
import Foundation

@testable import Breakout

struct BrickLayoutLoaderTest {

    @Test func loadsValidJsonFile() throws {
        let loader = JsonBrickLayoutLoader()

        let config = try loader.load(fileName: "001-classic-breakout")

        #expect(config.levelName == "Classic Breakout Level 1")
        #expect(config.mapCols == 14)
        #expect(config.mapRows == 8)
    }

    @Test func throwsErrorForMissingFile() {
        let loader = JsonBrickLayoutLoader()

        #expect(throws: BrickLayoutLoaderError.self) {
            try loader.load(fileName: "nonexistent-file")
        }
    }
}
