# SkyLog Fixed Web Beta Path

This document defines the first fixed-link beta deployment path.

## Recommended Host

Use GitHub Pages first because SkyLog is already structured like a GitHub
portfolio project and the app builds to static web files.

## Before Deployment

Complete:

- `docs/beta-release-checklist.md`
- `docs/deployment-readiness.md`

Run from `app/`:

```text
flutter analyze
flutter test
flutter build web
```

## GitHub Pages Setup

1. Push the project to a GitHub repository.
2. Open the repository on GitHub.
3. Go to Settings -> Pages.
4. Set Build and deployment Source to GitHub Actions.
5. Go to Actions.
6. Run `Deploy SkyLog Web Beta`.
7. Wait for the workflow to finish.
8. Copy the Pages URL from the workflow summary.

The workflow lives at:

```text
.github/workflows/deploy-web.yml
```

## First Sharing Rule

Share the first fixed link with only 3-5 trusted testers.

Do not post it publicly yet. This is still a private beta link.

## What To Tell Testers

- Data is local to their browser/device.
- There is no account or cloud sync.
- They should use sample or non-sensitive data.
- SkyLog is not a flight control app.
- SkyLog is not an official safety system.
- They should read Tester Instructions in Profile before testing.

## Success Criteria

The fixed link is ready for v2.0 small-group testing when:

- The workflow deploys successfully.
- The Pages URL opens SkyLog.
- Profile shows the current version.
- Core workflow works on the deployed link.
- At least one tester can complete the feedback template.
