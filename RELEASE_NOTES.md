# Release Notes

## v1.0.1

Release date: 2026-03-08

### Highlights

- Refreshed the README into a GitHub release-style landing page
- Added a Mermaid diagram to explain the product flow at a glance
- Kept GitHub Pages deployment instructions aligned with the current workflow
- Prepared the repository for tag-and-release publishing

### Included Files

- `README.md`
- `RELEASE_NOTES.md`
- `pubspec.yaml`
- `.github/workflows/deploy-github-pages.yml`
- `web/index.html`
- `web/manifest.json`

### Verification Summary

- `git diff --check`
- `flutter analyze`
- `flutter build web --release --base-href /merge/`

### Notes

- The web build path assumes the repository is published at `/merge/`
- GitHub release creation depends on repository credentials being available in the environment
