# SkyLog

SkyLog is a long-term student app project for drone pilots and aerial creators.
It helps users turn each drone flight into a structured record with location,
date, duration, weather, drone model, media, and personal reflection.

## Project Goal

The first version of SkyLog will be a local-first mobile app. Users should be
able to create, view, edit, and export flight records without requiring an
account, cloud sync, or network connection.

## Why This Project Matters

Drone users often save photos and videos, but the context behind each flight is
easy to lose: where it happened, what the weather was like, which drone was
used, what went wrong, and what could be improved next time.

SkyLog focuses on the post-flight workflow. It is not meant to replace flight
control apps such as DJI Fly. Instead, it helps users organize flights as
searchable, reviewable creative records.

## MVP Scope

- Dashboard with flight statistics
- Add and delete flight records
- Flight log list
- Flight detail page
- Local browser/device storage for early testing
- Form validation for required fields
- Pre-flight safety checklist
- Checklist completion saved into new flight records
- Beta status and local-data privacy notes
- Copyable tester feedback template
- Beta release checklist
- Known limits and tester instructions
- Deployment readiness checks
- Fixed web beta deployment path
- JSON backup export copied to clipboard

## Current Stage

SkyLog v1.9: Fixed Web Beta Path.

The app currently supports:

1. Dashboard overview
2. Flight log list
3. Add flight form
4. Local save and reload
5. Delete flight records
6. Flight detail page
7. JSON backup export
8. Pre-flight checklist with saved progress
9. Checklist status attached to saved flight records
10. Beta status and local-data privacy notes
11. Copyable tester feedback template
12. Beta release checklist
13. Known limits and tester instructions
14. Deployment readiness checks
15. Fixed web beta deployment path
16. Early tester guide and feedback materials

This is still a private beta, but the app now includes the basic explanations a
tester needs before using it.

## Running The App

Open this folder in VS Code:

```text
Documents/skylog
```

Use the Run and Debug configuration:

```text
SkyLog Web (fixed storage)
```

This runs the app on a fixed local web port so browser storage can persist
between debug sessions.

## Early Testing Materials

- `docs/demo-script.md`: short walkthrough script
- `docs/early-tester-guide.md`: what testers should try
- `docs/beta-release-checklist.md`: checks before sharing with testers
- `docs/deployment-readiness.md`: checks before creating a fixed web link
- `docs/fixed-web-beta-path.md`: first fixed-link beta deployment path
- `docs/feedback-form.md`: questions to ask after the demo
- `docs/project-summary-cn.md`: Chinese project summary
- `docs/version-learning-notes-cn.md`: Chinese learning notes by version
- `docs/v1-checklist.md`: v1.0 completion checklist
- `portfolio/checklist.md`: portfolio and application preparation checklist

## Repository Structure

```text
docs/
  demo-script.md
  beta-release-checklist.md
  deployment-readiness.md
  fixed-web-beta-path.md
  early-tester-guide.md
  feedback-form.md
  product-overview.md
  project-summary-cn.md
  version-learning-notes-cn.md
  project-log.md
  prd.md
  research-validation.md
  technical-plan.md
  vendor-flight-data.md
  user-manual.md
  v1-checklist.md

prototype/
  app-demo.html
  product-presentation.html

app/
  Flutter app source

portfolio/
  checklist.md
  screenshots/
  demo-video/
```

## Long-Term Direction

SkyLog is designed as a portfolio-quality project that combines software
engineering, product design, user research, and iteration. Future versions may
include DJI flight record import, AI-assisted flight summaries, richer map
visualization, and project-based media organization.
