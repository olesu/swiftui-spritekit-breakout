import Testing

struct MappingTest {

    @Test func flattenAnArray() async throws {
        let ints: [Int] = doFlatten(ints: [1, 2], inject: [3, 4, 5])
        
        #expect(ints == [1, 2, 3, 4, 5])
    }
    
    func doFlatten(ints: [Int], inject: [Int]) -> [Int] {
        return ints + inject
    }

}
