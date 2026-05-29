# SkyLog Beta Release Checklist

Use this checklist before sharing SkyLog with any outside tester.

## App State

- Confirm the app shows the current version and stage in Profile.
- Confirm Profile groups beta tools into Beta Testing, Project Info, and
  Release Tools.
- Open Web Update Tips in Profile.
- Confirm Automatic Web Deploy explains the release flow.
- Open Tester Quick Start in Profile.
- Reset demo data or create clean test records.
- Confirm Home shows realistic dashboard numbers.
- Confirm Checklist starts from a clear state.

## Core Workflow

- Complete the pre-flight checklist.
- Add a new flight record.
- Confirm the new flight appears in Logs.
- Open the flight detail page.
- Confirm checklist status is saved in the detail page.
- Edit the flight and confirm Logs updates.
- Delete a test flight and confirm it disappears.

## Data And Privacy

- Open Privacy and Local Data in Profile.
- Open Tester Instructions in Profile.
- Tell the tester records are stored locally on their browser/device.
- Tell the tester there is no account or cloud sync yet.
- Tell the tester not to enter sensitive or private data during beta testing.
- Export JSON Backup and confirm the dialog opens.

## Beta Boundaries

- Open About This Beta in Profile.
- Tell the tester SkyLog is not a flight control app.
- Tell the tester SkyLog is not an official safety system.
- Tell the tester to follow local drone rules and normal flight safety.
- Tell the tester browser/device changes may affect local data.

## Feedback

- Open Copy Feedback Template in Profile.
- Open Small Beta Feedback Plan in Profile.
- Give the tester the feedback questions after the test.
- Record useful feedback in `docs/project-log.md`.
- Decide whether the next version should fix confusion, improve stability, or
  prepare deployment.

## Release Rule

Do not share a fixed web link until this checklist passes without confusion.

Before creating a fixed web link, also complete
`docs/deployment-readiness.md`.

After deployment readiness passes, use `docs/fixed-web-beta-path.md` for the
first GitHub Pages beta link.
