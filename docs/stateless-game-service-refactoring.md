# Stateless Game Service Refactoring

## Current Architecture

```
BreakoutGameEngine (stateful)
├── Bricks (registry)
├── ScoreCard (state)
├── LivesCard (state)
└── GameStateAdapter (persists GameStatus only)
```

**Coupling:** Engine lifecycle tied to GameView. State scattered across multiple objects.

## Target Architecture

```
GameState (pure data)
├── score: Int
├── lives: Int
├── status: GameStatus
├── bricks: [BrickId: Brick]
└── ballResetNeeded: Bool

GameService (stateless)
└── Pure functions: (event, state) -> state

GameStateRepository (in-memory)
└── load() / save(state)
```

## Key Changes

### 1. Aggregate Root: GameState
- Complete game state as single immutable value
- Reuses existing `Brick` struct (id + color)
- Position (BrickArea) remains view-layer concern

### 2. Stateless Service
```swift
protocol GameService {
    func startGame(state: GameState) -> GameState
    func processEvent(_ event: GameEvent, state: GameState) -> GameState
}
```

### 3. Repository Pattern
```swift
protocol GameStateRepository {
    func load() -> GameState
    func save(_ state: GameState)
}
```

### 4. View Layer Flow
```
Load state → Apply event via service → Save state → Render
```

## Benefits

- **Pure functions** - Easier testing, no mocking required
- **Explicit state transitions** - Load → Transform → Save
- **Lifecycle independence** - View can recreate freely
- **Learning DDD** - Aggregate roots, repositories, domain services

## Migration Approach (TDD)

1. Define `GameState` model
2. Create `GameService` interface + tests
3. Implement stateless service (reuse existing logic)
4. Create in-memory repository
5. Update GameView to use new architecture
6. Remove old `BreakoutGameEngine`

## Non-Goals

- Persistent storage (in-memory only for now)
- Event sourcing
- Performance optimization (in-memory is fast enough)
