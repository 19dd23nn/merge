# Merge Game

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-0A7EA4)](./web/)
[![Release](https://img.shields.io/badge/Release-v1.0.1-111827)](./RELEASE_NOTES.md)

> A Flutter merge-board prototype that mixes pet collection, task progression, resource loops, and GitHub Pages delivery.

## Latest Release

- GitHub release: [`v1.0.1`](https://github.com/19dd23nn/merge/releases/tag/v1.0.1)
- Release notes: [RELEASE_NOTES.md](./RELEASE_NOTES.md)
- Web deployment: GitHub Pages via [`.github/workflows/deploy-github-pages.yml`](./.github/workflows/deploy-github-pages.yml)

## Why This Project

Merge Game explores a casual progression loop where pets, board merges, timed resources, and lightweight shop/navigation systems are combined into a Flutter-first prototype that can also ship to the web.

## Play / Test Locally

```bash
flutter pub get
flutter run
```

For browser testing:

```bash
flutter config --enable-web
flutter run -d chrome
```

## Current Highlights

- Release-focused README refresh with a GitHub-safe visual overview
- GitHub Pages deployment workflow for Flutter Web
- Web metadata updated for a product-facing presentation
- Release notes prepared for GitHub release publishing

## Visual Overview

```mermaid
flowchart LR
    Splash[Splash Screen] --> Shell[Main Container]
    Shell --> Pets[Pets Collection]
    Shell --> Home[Merge Board]
    Shell --> Settings[Settings]
    Home --> Packs[Feed / Water Packs]
    Packs --> Merge[Merge Items]
    Merge --> Tasks[Task Rotation]
    Tasks --> Coins[Coin Rewards]
    Coins --> Packs
```

## Visual Preview

<p align="center">
  <img src="./assets/board.png" alt="Merge board art preview" width="45%" />
  <img src="./assets/jessica.png" alt="Character progression preview" width="30%" />
</p>

## What Ships Today

| Area | Included |
| --- | --- |
| Core loop | 9x7 merge board with level-based merge rules |
| Progression | Task rotation, rewards, pack cooldowns, resource loop |
| Screens | Splash, pets, home, settings placeholder, shop |
| Platforms | Android, iOS, Flutter Web |
| Delivery | GitHub Pages workflow + release notes |

## Development

### Requirements

- Flutter SDK with Web support enabled
- Dart SDK compatible with the Flutter toolchain

### Install

```bash
flutter pub get
```

### Run locally

```bash
flutter run
```

### Run on Chrome

```bash
flutter config --enable-web
flutter run -d chrome
```

### Build for GitHub Pages

```bash
flutter build web --release --base-href /merge/
```

Use `/merge/` for this repository's current GitHub Pages path. If the repository is published as `username.github.io`, switch the base href to `/`.

Known caveats:

- `spine_flutter` should be validated against the current Flutter web toolchain before every release.
- Some screens still contain placeholder or mock behavior, especially settings and purchase handling.

## Repository Layout

```text
lib/
  main.dart                     # App entry and main merge gameplay screen
  main_container.dart           # Navigation shell
  widgets/merge_game_board.dart # Board interaction logic
  data/                         # Task data and repository
  services/                     # Coin, energy, board state
  screens/                      # Pets, shop, inbox, settings
web/                            # Flutter web shell and manifest
assets/                         # Game images, packs, pets, UI assets
```

## Deployment

The GitHub Pages workflow is defined in [`.github/workflows/deploy-github-pages.yml`](./.github/workflows/deploy-github-pages.yml).

1. Push to `main` or run the workflow manually.
2. GitHub Actions builds Flutter Web with a repo-aware `base-href`.
3. `build/web` is uploaded and deployed to GitHub Pages.

One-time GitHub setup:

1. Open `Settings > Pages`
2. Set the source to `GitHub Actions`

## Release Publishing

Pages deployment and GitHub release publishing are separate steps.

1. Bump the app version in [`pubspec.yaml`](./pubspec.yaml).
2. Run the release validation checklist below.
3. Commit and push to `main`.
4. Create and push a release tag.
5. Publish the GitHub release with the matching notes.

## Release Checklist

- `flutter pub get`
- `flutter analyze --no-fatal-infos`
- `flutter build web --release --base-href /merge/`
- Confirm GitHub Pages still expects the `/merge/` base path
- Open the deployed site and smoke test splash, home, and one secondary navigation path

## Release Notes Reference

The release summary for this iteration lives in [RELEASE_NOTES.md](./RELEASE_NOTES.md).

## Notes

- Firebase configuration files exist, but the current app entry does not initialize Firebase.
- Current web builds emit wasm dry-run warnings from `spine_flutter`, but the JS/web bundle still builds successfully.

## Key Files

- [`lib/main.dart`](./lib/main.dart)
- [`lib/main_container.dart`](./lib/main_container.dart)
- [`lib/widgets/merge_game_board.dart`](./lib/widgets/merge_game_board.dart)
- [`lib/data/board_task_repository.dart`](./lib/data/board_task_repository.dart)
- [`web/index.html`](./web/index.html)
- [`RELEASE_NOTES.md`](./RELEASE_NOTES.md)
