# YellowStar Network — Plan

## Goal

One Minecraft **Java Edition** network with a lobby, BedWars, Survival economy, more minigames, and an original game mode.

## Proposed layout

```text
Java players
    |
 Velocity proxy
    |
    +-- Lobby (Paper)
    +-- BedWars (Paper + compatible game plugin)
    +-- Survival (Paper + economy/claims/shop plugins)
    +-- Minigames (added as needed)
    +-- Custom mode (later)
```

This is the target layout, not a claim that the servers are already installed or running.

## Compatibility strategy

First make the modern network stable. The initial target is Java 1.21.1 gameplay. Multi-version support will be tested with maintained protocol compatibility plugins. If 1.8.9 support or old-style combat requires a legacy backend, add a separate legacy server rather than compromising every modern mode.

Compatibility depends on the exact versions of the proxy, server software, protocol plugins, and gameplay plugins. Test each combination before opening the network publicly.

## Stages

1. Repository and safe local startup scaffolding.
2. Install and start a local proxy and lobby.
3. Add BedWars and test a complete match.
4. Add Survival economy and land protection.
5. Add additional minigames and the original mode.
6. Test Java client compatibility, permissions, backups, and performance.
7. Only then consider public hosting and network security.

## Local-first rules

- Keep server JARs, worlds, logs, and player data out of Git.
- Do not expose a local server to the internet before permissions, online-mode/authentication, firewall, and proxy forwarding are configured correctly.
- Keep backups before changing world or plugin versions.
