# SkyLog Automatic Web Deploy

SkyLog v2.1 changes the web beta deployment workflow from manual-only to
automatic after stable pushes to `main`.

## Fixed Web Link

```text
https://houjue919.github.io/skylog/
```

The link stays the same. New stable versions update the app at that link.

## Release Flow

Use this process for future versions:

1. Build the next small feature locally.
2. Run `flutter analyze`.
3. Run `flutter test`.
4. Run `flutter build web`.
5. Commit the stable version.
6. Push to `main`.
7. GitHub Actions automatically builds and deploys the web beta.

## Why This Matters

Automatic deployment makes the project easier to maintain, but the quality gate
stays local: only push to `main` after the app passes checks.

## Safety Rule

Do not push unfinished work to `main`. Use small, stable milestones so the
public beta link stays reliable.
