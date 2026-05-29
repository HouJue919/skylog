# SkyLog Project Log

Use this file to record weekly progress, decisions, challenges, and reflections.
This will help turn the project into a strong long-term portfolio story.

## 2026-05-26

### Progress

- Organized the SkyLog project repository.
- Moved product, research, technical, and user documentation into `docs/`.
- Moved the early HTML prototypes into `prototype/`.
- Created the first project README.
- Installed and verified Flutter.
- Created the first Flutter project inside `app/`.
- Replaced the default Flutter counter app with the first static SkyLog
  Dashboard screen.
- Added bottom navigation for Home, Logs, Add, Map, and Profile.
- Added a basic widget test for the SkyLog Dashboard.
- Added a widget test for switching between the main navigation sections.
- Completed the SkyLog v0.1 static app prototype milestone.
- Built static versions of Flight Logs, Add Flight, Flight Map, and Profile.
- Started SkyLog v0.2 by adding an in-memory `FlightRecord` data model.
- Connected the Add Flight form to the Flight Logs list.
- Added a test that creates a flight record and verifies that it appears in Logs.
- Started SkyLog v0.3 by adding `shared_preferences` for local record storage.
- Added JSON serialization so flight records can be saved and loaded locally.
- Added a VS Code fixed-port web launch configuration so browser local storage
  can persist between debug runs.
- Changed the fixed web port to `5055` because port `5000` was already in use
  on the computer.
- Added delete support for flight records and saved the updated list locally.
- Added an empty state for Flight Logs when there are no records.
- Started SkyLog v0.4 by adding a Flight Detail screen.
- Made Flight Log cards open the detail screen with full record information.
- Replaced simple save checks with Flutter `Form` validation for required
  fields.
- Added tests for opening flight details and form validation errors.
- Started SkyLog v0.5 as an early tester readiness milestone.
- Added version and stage information to the Profile screen.
- Added an early tester guide in `docs/early-tester-guide.md`.
- Reset the Add Flight form after saving a record.
- Added tests for v0.5 profile version display and form reset behavior.
- Started SkyLog v0.6 as a demo and feedback kit milestone.
- Added a demo script, feedback form, and portfolio checklist.
- Updated the README with current version, running instructions, and early
  testing materials.
- Started SkyLog v0.7 by adding search to Flight Logs.
- Users can search by title, location, date, duration, drone, weather, or
  summary.
- Added no-results feedback and a clear search button.
- Added tests for successful search and no-result search states.
- Started SkyLog v0.8 by adding edit support for existing flight records.
- Added editable detail fields and an Edit/Save action on the Flight Detail
  screen.
- Updated the saved local list after edits.
- Added a test that edits a detail record and confirms the Logs list updates.
- Started SkyLog v0.9 as a visual polish and screenshot preparation milestone.
- Updated the Dashboard so statistics and recent logs come from actual saved
  flight records instead of fixed placeholder numbers.
- Added a Chinese screenshot plan in `portfolio/screenshot-plan.md`.
- Added JSON backup export from the Profile screen.
- Export copies formatted JSON to the clipboard and shows a preview dialog.
- Added a test for the JSON export flow.
- Added `docs/v1-checklist.md` to define the first complete MVP target.
- Added `docs/project-summary-cn.md` as a Chinese project summary for personal
  understanding and future application material.
- Completed the SkyLog v1.0 MVP verification.
- Added a full v1 workflow test covering add, save, search, detail, edit,
  delete, and export.
- Confirmed `flutter analyze` passes and 13 widget tests pass.
- Added `docs/version-learning-notes-cn.md` to summarize what each version
  taught from v0.1 through v1.0.
- Started SkyLog v1.1 as a portfolio polish milestone.
- Updated the current app version label to `SkyLog v1.1`.
- Updated Profile, README, demo script, and screenshot plan to use the current
  portfolio polish stage.
- Lightly polished the Home Dashboard header and latest flight card.
- Added Reset Demo Data in Profile to restore clean sample records for
  screenshots.
- Updated the screenshot plan to use Reset Demo Data before capturing images.
- Fixed demo data so the list remains editable after reset.
- Generated the first portfolio screenshot set in `portfolio/screenshots/`.
- Fixed a mobile-size Dashboard stat card overflow found during screenshot
  generation.
- Confirmed `flutter analyze` passes and the full test suite passes after
  screenshot generation.
- Started SkyLog v1.2 as a flight safety checklist milestone.
- Replaced the placeholder Map tab with a practical Pre-flight Checklist tab.
- Added six pre-flight safety checks and saved checklist progress locally.
- Added Dashboard checklist progress and quick actions for Add Flight and
  Checklist.
- Updated the current app version label to `SkyLog v1.2`.
- Added a widget test for completing and resetting the pre-flight checklist.
- Confirmed `flutter analyze` passes and the full test suite passes after v1.2.
- Started SkyLog v1.3 as a checklist-linked logs milestone.
- Added checklist completion fields to `FlightRecord` and JSON export.
- Add Flight now saves the current checklist completion into the new flight
  record.
- Saving a flight resets the active checklist for the next flight session.
- Flight Logs and Flight Detail now show saved checklist status.
- Updated the current app version label to `SkyLog v1.3`.
- Added a widget test for saving checklist status into a flight record.
- Confirmed `flutter analyze` passes and the full test suite passes after v1.3.
- Started SkyLog v1.4 as a public beta readiness milestone.
- Updated the current app version label to `SkyLog v1.4`.
- Added Profile notes explaining beta status and local-only data storage.
- Added tests for the beta explanation and privacy/local data dialogs.
- Confirmed `flutter analyze` passes and the full test suite passes after v1.4.
- Started SkyLog v1.5 as a tester feedback kit milestone.
- Updated the current app version label to `SkyLog v1.5`.
- Added a copyable beta feedback template in Profile.
- Made the feedback template dialog open even if clipboard access is delayed.
- Updated the early tester guide for the current checklist-linked workflow.
- Added a widget test for opening the feedback template dialog.
- Confirmed `flutter analyze` passes and the full test suite passes after v1.5.
- Started SkyLog v1.6 as a beta release checklist milestone.
- Updated the current app version label to `SkyLog v1.6`.
- Added a Profile entry for Beta Release Checklist.
- Added `docs/beta-release-checklist.md` as the required pre-sharing checklist.
- Added a widget test for opening the beta release checklist dialog.
- Confirmed `flutter analyze` passes and the full test suite passes after v1.6.
- Started SkyLog v1.7 as a known limits and tester instructions milestone.
- Updated the current app version label to `SkyLog v1.7`.
- Added a Profile entry for Tester Instructions.
- Added tester guidance for local data limits, sample data, and safe beta use.
- Updated the early tester guide and beta release checklist with known limits.
- Added a widget test for opening the tester instructions dialog.
- Confirmed `flutter analyze` passes and the full test suite passes after v1.7.
- Started SkyLog v1.8 as a deployment readiness milestone.
- Updated the current app version label to `SkyLog v1.8`.
- Added a Profile entry for Deployment Readiness.
- Added `docs/deployment-readiness.md` for fixed web link preparation.
- Added a widget test for opening the deployment readiness dialog.
- Confirmed `flutter analyze`, `flutter test`, and `flutter build web` pass.
- Started SkyLog v1.9 as a fixed web beta path milestone.
- Updated the current app version label to `SkyLog v1.9`.
- Added a Profile entry for Fixed Web Beta Path.
- Added `.github/workflows/deploy-web.yml` for manual GitHub Pages deployment.
- Added `docs/fixed-web-beta-path.md` to document the first fixed-link beta
  route.
- Added a widget test for opening the fixed web beta path dialog.
- Deployed the first fixed GitHub Pages web beta.
- Started SkyLog v2.0 as a small beta feedback milestone.
- Updated the current app version label to `SkyLog v2.0`.
- Added a Profile entry for Small Beta Feedback Plan.
- Added `docs/small-beta-feedback-plan.md` to define the first feedback process.
- Added a widget test for opening the small beta feedback plan dialog.
- Started SkyLog v2.1 as an automatic web deployment milestone.
- Updated the current app version label to `SkyLog v2.1`.
- Updated `.github/workflows/deploy-web.yml` so pushes to `main` deploy the web
  beta automatically.
- Added a Profile entry for Automatic Web Deploy.
- Added `docs/automatic-web-deploy.md` to document the stable release flow.
- Added a widget test for opening the automatic web deploy dialog.
- Started SkyLog v2.2 as a tester quick start milestone.
- Updated the current app version label to `SkyLog v2.2`.
- Added a Profile entry for Tester Quick Start.
- Added `docs/tester-quick-start.md` for the first-test path.
- Added a widget test for opening the tester quick start dialog.
- Started SkyLog v2.3 as an organized beta profile milestone.
- Updated the current app version label to `SkyLog v2.3`.
- Reorganized Profile beta tools into Beta Testing, Project Info, and Release
  Tools.
- Added a widget test check for the new Profile beta sections.
- Started SkyLog v2.4 as a web update guidance milestone.
- Updated the current app version label to `SkyLog v2.4`.
- Added a Profile entry for Web Update Tips.
- Added `docs/web-update-guidance.md` to explain browser cache refresh steps.
- Added a widget test for opening the web update tips dialog.
- Started SkyLog v2.5 as a creative review fields milestone.
- Updated the current app version label to `SkyLog v2.5`.
- Added purpose, issues, and next improvements fields to `FlightRecord`.
- Added creative review inputs to the Add Flight and Flight Detail flows.
- Included creative review fields in search and JSON backup export.
- Added a widget test for saving and reviewing creative flight notes.
- Started SkyLog v2.6 as a map coordinates milestone from Sprint 3.
- Updated the current app version label to `SkyLog v2.6`.
- Added optional latitude and longitude fields to `FlightRecord`.
- Add Flight can now save map-ready coordinates.
- Flight Detail now shows a coordinate label and map-style preview.
- Added a widget test for saving and reviewing flight coordinates.
- Started SkyLog v2.7 as a media metadata milestone from Sprint 3.
- Updated the current app version label to `SkyLog v2.7`.
- Added media type, media path, and media caption fields to `FlightRecord`.
- Add Flight can now save basic media metadata without cloud upload.
- Flight Detail now shows a media section and placeholder preview.
- Included media metadata in search and JSON backup export.
- Added a widget test for saving and reviewing media metadata.
- Started SkyLog v2.8 as a flight map footprint milestone from Sprint 3.
- Updated the current app version label to `SkyLog v2.8`.
- Added a Map tab to the bottom navigation.
- Reworked Flight Map to use real flight records with saved coordinates.
- Added mapped flight stats and tappable mapped flight summaries.
- Added a widget test for opening a mapped flight detail from Map.
- Started SkyLog v2.9 as a profile statistics milestone from Sprint 4.
- Updated the current app version label to `SkyLog v2.9`.
- Added Pilot Stats to Profile using real saved flight records.
- Replaced static My Drones examples with drone usage counts from records.
- Added primary drone, flight time, mapped flight, and media flight summaries.
- Added a widget test for Profile flight and drone statistics.
- Started SkyLog v3.0 as a CSV export milestone from Sprint 4.
- Updated the current app version label to `SkyLog v3.0`.
- Added CSV table export from Profile.
- CSV export includes flight basics, coordinates, drone, weather, media, review,
  and checklist fields.
- Added a widget test for opening the CSV export dialog.
- Started SkyLog v3.1 as a device profile milestone from Sprint 4.
- Updated the current app version label to `SkyLog v3.1`.
- Upgraded My Drones from simple usage counts to generated device profiles.
- Device profiles now show flights, total time, latest flight, mapped records,
  and media records.
- Added widget test coverage for the richer device profile summaries.
- Started SkyLog v3.2 as a backup report milestone from Sprint 4.
- Updated the current app version label to `SkyLog v3.2`.
- Added a Backup Report card above the Profile export buttons.
- Backup Report summarizes record count, total flight time, map-ready records,
  media-linked records, export options, and local-device risk.
- Added widget test coverage for the Backup Report summary.
- Started SkyLog v3.3 as the first Sprint 5 readiness milestone.
- Updated the current app version label to `SkyLog v3.3`.
- Added an AI Prompt Preview section to Flight Detail.
- Prompt preview shows the future AI input fields without making a network
  request or using an API key.
- Added widget test coverage for opening the AI Prompt Preview.

### Reflection

The project is now structured like a real software project instead of a group of
separate notes. Flutter is also ready, so the project can now move from planning
into app development. The first visible screen now matches the SkyLog direction
instead of the default Flutter starter app. The app also has a basic navigation
shell, which makes it feel more like a real mobile product. SkyLog v0.1 is now a
working static prototype: it does not save real data yet, but it communicates
the product structure clearly. SkyLog v0.2 has begun moving from static screens
to real interaction by letting one screen create data that another screen shows.
SkyLog v0.3 begins the next step: persistence, so records can survive app
restart instead of living only in memory. The logs screen also now supports
deleting records, which makes the prototype more usable for early testing.
SkyLog v0.4 makes each record feel more complete by adding a detail view and
clearer form validation. SkyLog v0.5 prepares the app for a small private
walkthrough by adding tester-facing context and smoother repeated record entry.
SkyLog v0.6 adds the materials needed to run a structured private demo and
collect useful feedback. SkyLog v0.7 makes the log list more useful by letting
users find records instead of only scrolling through them. SkyLog v0.8 completes
the basic CRUD loop: users can create, read, update, and delete flight records.
SkyLog v0.9 improves presentation readiness by making Dashboard data more
honest and planning the screenshots needed for a portfolio. The app also now
supports JSON export, which completes an important local-first backup feature.
The v1.0 checklist and Chinese summary make the project easier to review before
the first MVP milestone is declared complete. SkyLog v1.0 is now complete as a
local-first MVP. The version learning notes connect each milestone to the
programming and product concepts learned along the way. SkyLog v1.1 begins
presentation polish so the app is easier to screenshot and explain. Reset Demo
Data makes it easier to prepare clean screenshots without manual cleanup.
SkyLog v1.2 shifts back from presentation to product value by adding a
pre-flight safety workflow. This makes the app useful before a flight, not only
after one. SkyLog v1.3 connects that safety workflow to the flight log itself,
so a saved record can show how prepared the pilot was before takeoff. SkyLog
v1.4 improves tester trust by clearly explaining what the beta is, where data is
stored, and what the app should not be used for. SkyLog v1.5 makes private beta
testing easier by giving testers a structured feedback template directly inside
the app. SkyLog v1.6 turns private beta preparation into a repeatable checklist
so the app is not shared until core flows, data notes, and tester feedback are
ready. SkyLog v1.7 adds clearer tester instructions and known limits so outside
testers understand what to try, what data to avoid, and what the beta cannot do.
SkyLog v1.8 verifies that the app can build for Flutter Web and documents the
checks needed before creating a fixed beta link. SkyLog v1.9 turns that
readiness into a concrete GitHub Pages route, while keeping the first fixed link
limited to a small trusted tester group. SkyLog v2.0 begins the feedback stage:
the app now guides who should test, what they should try, and how feedback
should be recorded before more features are added. SkyLog v2.1 improves the
release workflow by making stable pushes to `main` automatically update the
fixed beta website after the local checks pass. SkyLog v2.2 makes the first
tester experience clearer by giving new beta testers a short path to follow
before they send feedback. SkyLog v2.3 reduces Profile clutter by grouping beta
tools around what testers need first and what release/developer tools can stay
later. SkyLog v2.4 addresses a real deployment issue from testing: browsers can
cache an older Flutter Web version, so testers now get clear refresh guidance.
SkyLog v2.5 returns to product depth by helping pilots record why a flight
happened, what went wrong, and what they should improve next.
SkyLog v2.6 begins the original Sprint 3 map work by saving coordinates before
adding a full map provider.
SkyLog v2.7 continues Sprint 3 by linking flight records to media notes without
taking on photo permissions, file copying, or cloud upload yet.
SkyLog v2.8 connects the saved coordinates back into the main app navigation so
the map footprint is no longer only a placeholder.
SkyLog v2.9 begins Sprint 4 by making the Profile page summarize real records
instead of showing fixed drone examples.
SkyLog v3.0 adds a spreadsheet-friendly export path so records can be reviewed
outside the app, not only backed up as JSON.
SkyLog v3.1 makes the device section more useful by turning drone names into
small profile summaries generated from real flight records.
SkyLog v3.2 closes the Sprint 4 backup thread by showing users what their
exports contain and reminding them that records still live on the current
browser/device.
SkyLog v3.3 starts Sprint 5 carefully by previewing prompt structure and data
boundaries before any real AI service is connected.

### Next Step

- Continue Sprint 5 with a local draft summary generator before any real AI
  gateway.
- Keep generated device profiles simple before adding separate editable drone
  files.
- Use feedback to decide whether spreadsheet export, backup reporting, and
  device summaries are useful for testers.
