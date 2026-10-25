# YellowStar Network MC

Minecraft Java network project by Yan Elias.

## Game modes

- **Lobby** — central spawn, navigation and player information.
- **BedWars** — team-based matches, beds, generators, shops and arenas.
- **Survival** — economy, claims, shops and community builds.
- **Minigames** — room for additional game modes.
- **Original mode** — a custom mode to design after the core network is stable.

## Architecture

The project is being built in stages for a lightweight local development setup on Linux.

- **Velocity** — proxy and network entry point.
- **Paper** — modern Java server backend.
- **Legacy compatibility** — evaluated after the base network works; old clients and old gameplay may need a separate backend and compatible plugins.
- **Configuration and scripts** — stored in this repository; server binaries and world data are not committed.

## Development status

The repository is currently being initialized. No game server is ready to publish yet.

See [NETWORK_PLAN.md](NETWORK_PLAN.md) for the staged plan.

## Requirements

- Linux (BigLinux/Manjaro is the current development environment).
- Java runtime compatible with each selected server version.
- Internet access to obtain official server software and plugins.

## Safety

Only download server software and plugins from their official project pages. Never put passwords, tokens, or private server addresses in this repository.
