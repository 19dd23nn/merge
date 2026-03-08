# Merge Game

`merge` is a Flutter-based merge board prototype with pet collection, task progression, a shop screen, and simple resource systems for coins and energy.

## Features

- 9x7 merge board with draggable items and level-based merge rules
- Pack cooldown and board state persistence
- Task rotation with coin rewards
- Pet collection screen with lock/progress states
- Shop mock UI with categorized items
- Splash screen and tab-based navigation
- Android, iOS, and Flutter Web support

## Tech Stack

- Flutter 3 / Dart 3
- `provider`
- `spine_flutter`
- Firebase config files for Android and Web

## Project Structure

```text
lib/
  main.dart                     # App entry and main merge gameplay screen
  main_container.dart           # Bottom navigation container
  widgets/merge_game_board.dart # Core board interaction logic
  data/                         # Task models and repository
  services/                     # Coin, energy, and board state services
  screens/                      # Pets, shop, inbox, settings
web/                            # Flutter web shell
assets/                         # Game images, packs, pets, and UI assets
```

## Local Development

### Requirements

- Flutter SDK with Web support enabled
- Dart SDK matching the Flutter version used by the project

### Install dependencies

```bash
flutter pub get
```

### Run on a connected device

```bash
flutter run
```

### Run in Chrome

```bash
flutter config --enable-web
flutter run -d chrome
```

### Build for the web

```bash
flutter build web --release --web-renderer canvaskit --base-href /merge/
```

Use `/merge/` for this repository's GitHub Pages deployment path. If you deploy the app from a user or organization site such as `username.github.io`, use `/` instead.

## GitHub Pages Deployment

This repository includes a GitHub Actions workflow at [`.github/workflows/deploy-github-pages.yml`](./.github/workflows/deploy-github-pages.yml) that:

1. Checks out the repository
2. Installs Flutter
3. Builds the web app with the correct `--base-href`
4. Uploads `build/web`
5. Deploys the artifact to GitHub Pages

### One-time GitHub setup

1. Open the repository on GitHub.
2. Go to `Settings > Pages`.
3. Set the source to `GitHub Actions`.
4. Push to `main` or run the workflow manually.

The workflow automatically uses `/` for `*.github.io` repositories and `/<repo-name>/` for project pages like this repository.

## Notes

- The app currently contains placeholder content in some screens and mock purchase handling in the shop UI.
- Firebase configuration is present in [`firebase.json`](./firebase.json), but the current app entry does not initialize Firebase.
- `spine_flutter` is initialized at app startup, so the GitHub Pages workflow builds the web bundle with `--web-renderer canvaskit`.
- This environment could not run `flutter` commands because the local Flutter SDK attempted to write outside the workspace sandbox.

## Key Files

- [`lib/main.dart`](./lib/main.dart)
- [`lib/main_container.dart`](./lib/main_container.dart)
- [`lib/widgets/merge_game_board.dart`](./lib/widgets/merge_game_board.dart)
- [`lib/data/board_task_repository.dart`](./lib/data/board_task_repository.dart)
- [`web/index.html`](./web/index.html)

## JEO Orchestration Workflow

Keyword: `jeo` | Tool: Gemini CLI

JEO provides integrated AI agent orchestration across all AI tools.

### Workflow Phases

#### 1. PLAN (plannotator)
- Write `plan.md` (Goals, Steps, Risks, Completion Criteria).
- Run the PLAN gate loop (blocks until approved):
  ```bash
  bash .agent-skills/jeo/scripts/plannotator-plan-loop.sh plan.md /tmp/plannotator_feedback.txt 3
  ```
- Review `/tmp/plannotator_feedback.txt`. Proceed to EXECUTE only if `"approved":true`.

#### 2. EXECUTE (BMAD for Gemini)
- Initialize workflow: `/workflow-init`
- Check status: `/workflow-status`
- Phases: Analysis → Planning → Solutioning → Implementation

#### 3. VERIFY (agent-browser)
- UI/Functionality check:
  ```bash
  agent-browser snapshot http://localhost:3000
  ```

#### 4. CLEANUP (worktree)
- Post-work cleanup:
  ```bash
  bash /Users/hans/Desktop/.agents/skills/jeo/scripts/worktree-cleanup.sh
  ```

#### 5. ANNOTATE (agentation)
When requested to process UI annotations:
- Check pending: `GET http://localhost:4747/pending`
- Resolve annotations sequentially until count is 0.

---

## ohmg Integration

For Gemini multi-agent orchestration:

```bash
bunx oh-my-ag           # Initialize ohmg
/coordinate "<task>"    # Coordinate multi-agent task
```
