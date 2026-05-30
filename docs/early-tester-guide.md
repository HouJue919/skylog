# SkyLog Early Tester Guide

## Current Version

SkyLog v3.5 - Local Draft Summary

This is a private beta testing version. It is not a public release yet.

## What SkyLog Does

SkyLog helps drone pilots check basic pre-flight items and record each flight
with location, optional map coordinates, date, duration, drone model, weather,
media notes, checklist status, and a short creative review. The goal is to turn
scattered flight memories into searchable flight records and clear improvement
notes.

## What To Test

Please try these basic flows:

1. Open Tester Quick Start in Profile.
2. Open Web Update Tips if the app appears outdated.
3. Open the app and review the Home screen.
4. Go to Checklist and complete the pre-flight checks.
5. Go to Add and create a new flight record.
6. Fill in Latitude and Longitude if you want to test map-ready records.
7. Fill in Media Type, Media Path, and Media Caption if you have a sample clip
   or photo name.
8. Fill in Purpose, Issues, and Next Improvements if you have time.
9. Go to Logs and confirm the new record appears.
10. Go to Map and confirm mapped records appear.
11. Tap a mapped record and confirm it opens the flight detail page.
12. Tap the flight record and check that checklist status, coordinates, media
   notes, and creative review notes appear in Detail.
13. Close and reopen the app, then confirm the record is still there.
14. Delete a test record from Logs.
15. Try saving with an empty title, location, or duration and check whether the
   app explains what is missing.
16. Go to Profile and confirm Pilot Stats and My Drones match the test records.
17. Confirm each drone profile shows total flights, total time, latest flight,
   mapped records, and media records.
18. Confirm Backup Report explains record count, export formats, and local-data
   risk.
19. Open a flight detail and preview the AI prompt.
20. Confirm the AI prompt preview says no API call is made.
21. Generate a Local Draft Summary and confirm it is marked as not AI output.
22. Go to Profile and switch Language between English and 中文.
23. Confirm the bottom navigation changes language.
24. Export JSON Backup and confirm the dialog opens.
25. Export CSV Table and confirm the table text opens.
26. Copy the feedback template.
27. Open Tester Instructions and confirm the limits are clear.

## Feedback Questions

- Is the purpose of SkyLog clear within the first minute?
- Which fields feel useful?
- Which fields feel annoying or unnecessary?
- Would you use this after a real drone flight?
- What information do you usually forget after flying?
- What would make the app more useful for drone photography or travel?

## Known Limits

- Records are saved locally on this device/browser only.
- There is no account or cloud sync.
- Switching devices or clearing browser data may remove saved records.
- Please use sample or non-sensitive flight data during beta testing.
- SkyLog is not a flight control app.
- SkyLog is not an official safety system.
- Images and videos are not connected yet.
- Drone profiles are generated from flight records, not edited as separate
  device files yet.
- Backup Report is a readiness summary, not automatic cloud backup.
- AI Prompt Preview does not call an API and does not generate real AI output.
- Local Draft Summary is rule-based and not real AI output.
- Language Settings is a starter and does not translate every screen yet.
- JSON export copies a backup to the clipboard.
- CSV export copies table-friendly text to the clipboard.
- Feedback template copy depends on the device/browser clipboard.
- Browser caching may show an older version briefly after deployment.

## Tester Note

This version is meant for private feedback from a small number of trusted
testers. Please focus on whether the workflow makes sense, not whether the app
feels finished.
