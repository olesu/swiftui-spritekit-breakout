# Learning Swift by Breakout

A classic Breakout game built in Swift using SpriteKit and Test-Driven Development (TDD).

## Overview

This project demonstrates clean architecture principles with strict separation between physics simulation and game logic:

- **SpriteKit handles physics** - Collision detection, rendering, user input
- **Domain handles game rules** - Scoring, lives, win/lose conditions, state management
- **Event-driven communication** - Clear boundaries between layers

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture documentation.

## Key Features

- Clean layered architecture with zero framework dependencies in domain layer
- Comprehensive test coverage with 35+ tests
- TDD approach throughout development (see [CLAUDE.md](CLAUDE.md))
- Protocol-oriented design with dependency injection
- Data-driven brick layouts via JSON configuration
- Color-based scoring system (Red/Orange: 7pts, Yellow: 4pts, Green: 1pt)
- Extracted testable components for complex physics calculations

## Quick Start

### Build and Run

Open `Breakout.xcodeproj` in Xcode and run (⌘R).

### Run Tests

```bash
xcodebuild test -scheme Breakout -destination 'platform=macOS'
```

## Project Structure

```
Breakout/
├── Domain/          # Pure game logic (framework-independent)
├── Game/            # Main game screen (SwiftUI + SpriteKit)
├── Nodes/           # SpriteKit sprites and physics
├── Physics/         # Extracted physics calculations
├── Navigation/      # State-based routing
└── Resources/       # JSON configurations
```

## Learning Resources

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Detailed architecture overview
- **[CLAUDE.md](CLAUDE.md)** - TDD guidelines and development workflow
