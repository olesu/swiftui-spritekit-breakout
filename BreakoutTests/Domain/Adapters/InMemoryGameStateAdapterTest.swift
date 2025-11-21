import Testing

@testable import Breakout

struct InMemoryGameStateAdapterTest {

    @Test func canStoreGameState() async throws {
        let storage = InMemoryStorage()
        let adapter = InMemoryGameStateAdapter(storage: storage)
        
        adapter.save(.playing)
        
        #expect(adapter.read() == .playing)
    }

}
