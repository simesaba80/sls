# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`sls` is a Swift CLI tool that lists directory contents and plays an ASCII art SL (Steam Locomotive) train animation in the terminal. It's a mashup of `ls` and `sl`.

## Commands

```bash
# Build
swift build

# Run
swift run sls <path> [--all] [--name <n>]

# Run the compiled binary directly
./.build/debug/sls <path>
```

No test targets or linting configuration exist in this project.

## Architecture

**Entry point:** `Sources/sls/sls.swift`
- Uses `ArgumentParser` (`@main struct sls: ParsableCommand`)
- Flags: `-a/--all` (show hidden files), `-n/--name` (unused integer option)
- Argument: `path` (directory to list)
- Flow: list files via `FileGeter` → print file names → get terminal size via `SetEmpty` → run animation via `SL.run()`

**`Sources/sls/lib/SL.swift`** — main animation engine
- Contains static ASCII art data for the train (smoke frames, body, wheels, coal wagon)
- `Cargo` struct for wagon configuration
- `run(row:col:)` renders the animation directly using ANSI escape sequences
- Train scrolls right-to-left; uses alternate screen buffer (`\u{1B}[?1049h/l`) like Vim
- ~60ms frame delay, 2-frame smoke, 6-frame wheel rotation

**`Sources/sls/lib/FileGeter.swift`** — lists directory files, respects `--all` flag

**`Sources/sls/lib/SetEmpty.swift`** — detects terminal dimensions via `ioctl()`; fallback is (24, 80)

## Key Dependencies

- **swift-argument-parser** — CLI argument parsing
- **TermKit** — pulled in as a dependency but animation was refactored to use direct ANSI codes instead of TermKit's View framework

## Platform Requirements

- macOS 13+
- Swift 6.2+
