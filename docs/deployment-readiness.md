# SkyLog Deployment Readiness

SkyLog should not be shared as a fixed web beta link until this checklist passes.

## Required Commands

Run these from `app/`:

```text
flutter analyze
flutter test
flutter build web
```

## Build Output

Flutter Web creates the deployable files in:

```text
app/build/web/
```

Those files can later be deployed to GitHub Pages, Netlify, or another static
web host.

SkyLog's first recommended fixed-link path is documented in:

```text
docs/fixed-web-beta-path.md
```

The GitHub Pages workflow lives in:

```text
.github/workflows/deploy-web.yml
```

## Manual Checks

- Open the local app and confirm Profile shows the current version.
- Open About This Beta.
- Open Privacy and Local Data.
- Open Tester Instructions.
- Open Beta Release Checklist.
- Open Deployment Readiness.
- Open Fixed Web Beta Path.
- Open Small Beta Feedback Plan.
- Complete the pre-flight checklist.
- Add a flight record.
- Confirm the record appears in Logs.
- Open Detail and confirm checklist status appears.
- Export JSON Backup.
- Copy Feedback Template.

## Beta Sharing Rule

The first fixed web link should only go to 3-5 trusted testers.

Do not post it publicly or on social media until tester feedback confirms:

- The purpose is clear.
- Local data limits are clear.
- The app does not feel like an official safety tool.
- The core workflow works without explanation.
- The feedback template is easy to use.

## Known Deployment Risk

SkyLog currently stores data in the browser/device. A deployed web link does not
mean cloud sync exists. Testers may lose records if they switch devices, switch
browsers, or clear browser data.
