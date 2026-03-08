# PRD: README and GitHub Deployment Improvements

## Objective

Present the repository as a real project and make Flutter Web deployable through GitHub Pages.

## Scope

- Rewrite the root README with accurate project description, setup steps, and deployment instructions.
- Add a GitHub Actions workflow that builds and deploys Flutter Web to GitHub Pages.
- Replace default web metadata placeholders with product-facing values.

## Out of Scope

- Changing gameplay logic
- Adding Firebase initialization
- Fixing unrelated app screens
- Bypassing environment restrictions on `git commit` or `git push`

## User Stories

### US-001 Repository visitor understands the project

As a developer visiting the repository, I want a README that describes the actual app and how to run it so that I can evaluate and work on the project quickly.

Acceptance Criteria:

- README no longer contains the default Flutter template text.
- README includes local run steps and Flutter Web build guidance.
- README notes current environment caveats honestly.

### US-002 Maintainer can deploy the web build from GitHub

As a maintainer, I want a GitHub Actions workflow for GitHub Pages so that the web app can be published directly from the repository.

Acceptance Criteria:

- Workflow triggers on `main` pushes and manual dispatch.
- Workflow computes the correct base href for project pages versus user pages.
- Workflow uploads `build/web` and deploys it via GitHub Pages actions.

### US-003 Deployed site has product-facing metadata

As an end user opening the deployed site, I want the browser title and manifest metadata to reflect the app name so that the deployment looks intentional.

Acceptance Criteria:

- `web/index.html` title and description are updated.
- `web/manifest.json` name, short name, and description are updated.

## Risks

- `spine_flutter` may require CanvasKit for web builds and may still fail in CI.
- `git push` cannot be completed from this sandbox if DNS/network remains unavailable.

## Done Definition

- Requested files are updated.
- Workflow YAML parses.
- JSON metadata parses.
- No diff formatting issues are reported.
- Push blocker is documented if still present.
