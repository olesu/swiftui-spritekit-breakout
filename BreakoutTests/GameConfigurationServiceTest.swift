import Foundation
import Testing

@testable import Breakout

struct GameConfigurationServiceTest {

    @Test func loadsTheGameConfig() async throws {
        let dataSource = MockGameConfigurationDataSource(data: validPlistData)
        let service = GameConfigurationService(using: dataSource)
        
        let config = try service.loadConfiguration()
        
        #expect(config == GameConfiguration(sceneWidth: 1024.0, sceneHeight: 768.0))
    }
    
    @Test func testLoadWithMissingFileThrowsResourceNotFound() throws {
        let resourceName = "GameConfiguration"
        let resourceExt = "plist"
        
        let mockDataSource = MockGameConfigurationDataSource(
            shouldThrowMissingResource: true
        )
        let service = GameConfigurationService(using: mockDataSource)
        
        try #expect(throws: GameConfigurationError.resourceNotFound(name: resourceName, ext: resourceExt)) {
            try service.loadConfiguration()
        }
    }
    
    @Test func testLoadWithInvalidDataThrowsDecodingFailed() throws {
        let invalidPlistData = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>sceneWidth</key>
            <real>1024.0</real>
        </dict>
        </plist>
        """.data(using: .utf8)!
        
        let mockDataSource = MockGameConfigurationDataSource(data: invalidPlistData)
        let service = GameConfigurationService(using: mockDataSource)
        
        #expect(throws: GameConfigurationError.decodingFailed) {
            try service.loadConfiguration()
        }
    }

}

enum MockError: Error {
    case missingResouce
}

struct MockGameConfigurationDataSource: GameConfigurationDataSource {
    let data: Data?
    let shouldThrowMissingResource: Bool
    
    init(data: Data? = nil, shouldThrowMissingResource: Bool = false) {
        self.data = data
        self.shouldThrowMissingResource = shouldThrowMissingResource
    }
    
    func data(forResource name: String, withExtension ext: String) throws -> Data {
        if shouldThrowMissingResource {
            throw MockError.missingResouce
        }
        
        guard let data = data else {
            fatalError("Mock data must be provided if not configured to throw")
        }
        return data
    }
}

private let validPlistData = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>sceneWidth</key>
    <real>1024.0</real>
    <key>sceneHeight</key>
    <real>768.0</real>
</dict>
</plist>
""".data(using: .utf8)!

