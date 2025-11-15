# Learning Swift by Breakout

A classic Breakout game built in Swift using SpriteKit and Test-Driven Development (TDD).

## Architecture

This project demonstrates clean architecture principles with clear separation between:

- **Domain Layer**: Pure game logic (scoring, lives, brick management)
  - `BreakoutGameEngine`: Processes game events and maintains game state
  - `ScoreCard`, `LivesCard`, `Bricks`: Game state management
  - No dependencies on UI frameworks

- **Presentation Layer**: SpriteKit rendering and physics
  - `GameScene`: Handles physics simulation and collision detection
  - `BrickNodeManager`: Manages brick sprite lifecycle
  - Sends events to domain layer via callbacks

- **Coordination Layer**: Connects UI and domain
  - `GameViewModel`: Coordinates between GameScene and BreakoutGameEngine
  - Uses closure-based callbacks for state updates

## Key Features

- Event-driven architecture with clear separation of concerns
- Comprehensive test coverage (12+ tests)
- TDD approach throughout development
- Color-based scoring system (Red/Orange: 7pts, Yellow: 4pts, Green: 1pt)
- Lives management and win/lose conditions

## Running Tests

```bash
xcodebuild test -scheme Breakout -destination 'platform=macOS'
```

## Development

See [CLAUDE.md](CLAUDE.md) for TDD guidelines and [TODO.md](Breakout/TODO.md) for detailed implementation status.
