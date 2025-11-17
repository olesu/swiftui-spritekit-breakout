# Development Instructions

## Test-Driven Development (TDD) - STRICT RED-GREEN-REFACTOR

**CRITICAL: Write ONE test at a time. Never batch multiple tests.**

The TDD cycle is:
1. **RED**: Write ONE failing test
2. **GREEN**: Write minimal production code to make that ONE test pass
3. **REFACTOR**: Improve code while keeping tests green
4. **REPEAT**: Go back to step 1 for the next test

### TDD Rules (MUST FOLLOW)
- Write EXACTLY ONE test at a time
- Run the test and verify it FAILS (RED)
- Write ONLY enough production code to make that ONE test pass
- Run the test and verify it PASSES (GREEN)
- Refactor if needed (keeping all tests green)
- THEN and ONLY THEN write the next test
- Never write multiple tests in one file before running them
- Never write production code without a failing test first
- Compilation failures count as failing tests

### Examples

❌ **WRONG - Writing multiple tests at once:**
```swift
@Test func testA() { ... }
@Test func testB() { ... }
@Test func testC() { ... }
// Don't do this! Write one test, make it pass, then write the next.
```

✅ **CORRECT - One test at a time:**
```swift
// Step 1: Write ONE test
@Test func testA() { ... }
// Step 2: Run it (RED)
// Step 3: Write production code
// Step 4: Run it (GREEN)
// Step 5: NOW write the next test
@Test func testB() { ... }
```

### Additional Rules
- If there is a test checklist, always update it when a test is completed
- The intent of the code should be clear and there is no need for additional comments
- If there is a TDD todo-list, check items off when test is green
