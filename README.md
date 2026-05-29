# SkyLog

SkyLog is a long-term student portfolio app project by **HouJue** for drone
pilots and aerial creators. It helps users turn each drone flight into a
structured record with location, date, duration, weather, drone model, media,
and personal reflection.

Live beta:

```text
https://houjue919.github.io/skylog/
```

This repository is public so the project can be reviewed as a student software
engineering and product design portfolio. It is not an open-source commercial
project.

## Project Goal

The first version of SkyLog will be a local-first mobile app. Users should be
able to create, view, edit, and export flight records without requiring an
account, cloud sync, or network connection.

The long-term goal is to show a real product iteration process: research,
prototype, implementation, testing, deployment, feedback, and improvement.

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
- Creative review fields for flight purpose, issues, and next improvements
- Optional latitude and longitude saved with flight records
- Media metadata fields for type, local path, and caption
- Flight Map tab with mapped flight summaries
- Profile statistics for flight time, mapped records, media records, and drones
- Beta status and local-data privacy notes
- Copyable tester feedback template
- Beta release checklist
- Known limits and tester instructions
- Deployment readiness checks
- Fixed web beta deployment path
- JSON backup export copied to clipboard

## Current Stage

SkyLog v2.9: Profile Statistics.

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
10. Creative review fields for purpose, issues, and next improvements
11. Optional latitude and longitude for map-ready records
12. Media metadata for type, local path, and caption
13. Flight Map tab with mapped flight summaries
14. Profile statistics and drone usage summaries
15. Beta status and local-data privacy notes
16. Copyable tester feedback template
17. Beta release checklist
18. Known limits and tester instructions
19. Deployment readiness checks
20. Fixed web beta deployment path
21. Small beta feedback plan
22. Automatic web deployment after stable pushes
23. Tester quick start
24. Organized beta profile sections
25. Web update guidance for cached beta links
26. Early tester guide and feedback materials

This is still a private beta, but the app now includes the basic explanations a
tester needs before using it.

## Version Roadmap

- v0.1-v0.4: basic app structure, add flow, local records, detail view, and
  validation.
- v0.5-v0.9: early tester preparation, search, edit, dashboard polish, and JSON
  export.
- v1.0: first local-first MVP.
- v1.1-v1.3: portfolio polish, pre-flight checklist, and checklist status saved
  into flight records.
- v1.4-v1.8: beta trust, privacy notes, tester instructions, release checklist,
  and web deployment readiness.
- v1.9: fixed GitHub Pages beta path.
- v2.0: small-group feedback plan for the first fixed-link beta testers.
- v2.1: automatic GitHub Pages deployment after stable pushes to main.
- v2.2: short first-test path for new beta testers.
- v2.3: Profile beta tools grouped into tester, project, and release sections.
- v2.4: guidance for testers when browsers cache an older web beta.
- v2.5: creative review fields for flight purpose, issues, and next
  improvements.
- v2.6: optional latitude and longitude fields for map-ready flight records.
- v2.7: media metadata fields for type, local path, and caption.
- v2.8: Flight Map tab with mapped flight summaries and detail links.
- v2.9: Profile statistics and drone usage summaries.
- v3.0 next: continue Sprint 4 with CSV export or stronger backup reporting.
- Later: feedback-driven fixes and public-facing polish before wider
  sharing.

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
- `docs/automatic-web-deploy.md`: automatic deployment process
- `docs/small-beta-feedback-plan.md`: v2.0 tester feedback plan
- `docs/tester-quick-start.md`: first-test path for beta testers
- `docs/web-update-guidance.md`: what to do if the web beta looks outdated
- `docs/feedback-form.md`: questions to ask after the demo
- `docs/project-summary-cn.md`: Chinese project summary
- `docs/version-learning-notes-cn.md`: Chinese learning notes by version
- `docs/v1-checklist.md`: v1.0 completion checklist
- `portfolio/checklist.md`: portfolio and application preparation checklist

## Authorship And License

SkyLog was created by **HouJue** as a student portfolio project.

The code and project materials are visible for review and educational reference,
but they may not be copied, redistributed, used commercially, or submitted as
someone else's work without permission. See `LICENSE` for details.

The Git commit history is intentionally preserved to show the project process
over time.

## Repository Structure

```text
docs/
  demo-script.md
  beta-release-checklist.md
  deployment-readiness.md
  fixed-web-beta-path.md
  automatic-web-deploy.md
  small-beta-feedback-plan.md
  tester-quick-start.md
  web-update-guidance.md
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
