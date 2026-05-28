import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skylog/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SkyLog dashboard renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    expect(find.text('SkyLog'), findsOneWidget);
    expect(find.text('Record every drone flight.'), findsOneWidget);
    expect(find.text('Latest Flight'), findsOneWidget);
    expect(find.text('Total Flights'), findsOneWidget);
  });

  testWidgets('bottom navigation switches main sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();
    expect(find.text('Coastal sunset practice'), findsWidgets);

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(
      find.text('Capture the core details while the flight is still fresh.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Checklist'));
    await tester.pumpAndSettle();
    expect(find.text('Pre-flight Checklist'), findsOneWidget);
    expect(find.text('0 of 6 complete'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('SkyLog v1.9'), findsOneWidget);
    expect(find.text('Fixed Web Beta Path'), findsOneWidget);
  });

  testWidgets('profile explains beta status and local data privacy', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('About This Beta'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('about-beta-button')));
    await tester.pumpAndSettle();

    expect(find.text('About This Beta'), findsWidgets);
    expect(find.textContaining('student-built beta'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('privacy-note-button')));
    await tester.pumpAndSettle();

    expect(find.text('Privacy and Local Data'), findsWidgets);
    expect(
      find.textContaining('stores flight records on this device'),
      findsOneWidget,
    );
  });

  testWidgets('profile copies tester feedback template', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('copy-feedback-template-button')),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final feedbackTopLeft = tester.getTopLeft(
      find.byKey(const Key('copy-feedback-template-button')),
    );
    await tester.tapAt(feedbackTopLeft + const Offset(120, 32));
    await tester.pumpAndSettle();

    expect(find.textContaining('Feedback Template'), findsWidgets);
    expect(find.text('Done'), findsOneWidget);
  });

  testWidgets('profile opens beta release checklist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('beta-release-checklist-button')),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final releaseChecklistTopLeft = tester.getTopLeft(
      find.byKey(const Key('beta-release-checklist-button')),
    );
    await tester.tapAt(releaseChecklistTopLeft + const Offset(120, 32));
    await tester.pumpAndSettle();

    expect(find.text('Beta Release Checklist'), findsWidgets);
    expect(
      find.textContaining('Before sharing SkyLog with a tester'),
      findsOneWidget,
    );
    expect(find.textContaining('data is local'), findsOneWidget);
  });

  testWidgets('profile opens tester instructions', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('tester-instructions-button')),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final instructionsTopLeft = tester.getTopLeft(
      find.byKey(const Key('tester-instructions-button')),
    );
    await tester.tapAt(instructionsTopLeft + const Offset(120, 32));
    await tester.pumpAndSettle();

    expect(find.text('Tester Instructions'), findsWidgets);
    expect(
      find.textContaining('Use sample or non-sensitive flight data'),
      findsOneWidget,
    );
    expect(find.textContaining('Records stay local'), findsOneWidget);
  });

  testWidgets('profile opens deployment readiness', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('deployment-readiness-button')),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final deploymentTopLeft = tester.getTopLeft(
      find.byKey(const Key('deployment-readiness-button')),
    );
    await tester.tapAt(deploymentTopLeft + const Offset(120, 32));
    await tester.pumpAndSettle();

    expect(find.text('Deployment Readiness'), findsWidgets);
    expect(find.textContaining('Run flutter build web'), findsOneWidget);
    expect(find.textContaining('private beta link'), findsOneWidget);
  });

  testWidgets('profile opens fixed web beta path', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('fixed-web-beta-path-button')),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final fixedLinkTopLeft = tester.getTopLeft(
      find.byKey(const Key('fixed-web-beta-path-button')),
    );
    await tester.tapAt(fixedLinkTopLeft + const Offset(120, 32));
    await tester.pumpAndSettle();

    expect(find.text('Fixed Web Beta Path'), findsWidgets);
    expect(find.textContaining('GitHub Pages'), findsOneWidget);
    expect(find.textContaining('3-5 trusted testers'), findsOneWidget);
  });

  testWidgets('pre-flight checklist can be completed and reset', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Checklist'));
    await tester.pumpAndSettle();

    expect(find.text('Pre-flight Checklist'), findsOneWidget);
    expect(find.text('0 of 6 complete'), findsOneWidget);

    for (final item in [
      'Battery charged and locked in',
      'Propellers clean and attached',
      'Weather and wind checked',
      'Takeoff area is clear',
      'Return-to-home point confirmed',
      'Storage card has space',
    ]) {
      await tester.scrollUntilVisible(
        find.text(item),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(
        find.ancestor(
          of: find.text(item),
          matching: find.byType(CheckboxListTile),
        ),
      );
      await tester.pumpAndSettle();
    }

    expect(find.text('Ready to fly'), findsOneWidget);

    await tester.tap(find.byKey(const Key('reset-checklist-button')));
    await tester.pumpAndSettle();

    expect(find.text('0 of 6 complete'), findsOneWidget);
  });

  testWidgets('profile exports JSON backup', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Export JSON Backup'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('export-json-button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('JSON Backup'), findsWidgets);
  });

  testWidgets('new flight saves checklist status and resets checklist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Checklist'));
    await tester.pumpAndSettle();

    for (final item in [
      'Battery charged and locked in',
      'Propellers clean and attached',
      'Weather and wind checked',
      'Takeoff area is clear',
      'Return-to-home point confirmed',
      'Storage card has space',
    ]) {
      await tester.scrollUntilVisible(
        find.text(item),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(
        find.ancestor(
          of: find.text(item),
          matching: find.byType(CheckboxListTile),
        ),
      );
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Checklist complete'), findsOneWidget);
    expect(
      find.text('This flight will save 6 of 6 pre-flight checks.'),
      findsOneWidget,
    );

    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), 'Checklist saved flight');
    await tester.enterText(fields.at(1), 'Safety field');
    await tester.enterText(fields.at(3), '14 min');

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Flight'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Checklist saved flight'));
    await tester.pumpAndSettle();
    expect(find.text('Pre-flight Checklist'), findsOneWidget);
    expect(find.text('6/6 checks'), findsOneWidget);
    expect(find.text('Ready before takeoff'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checklist'));
    await tester.pumpAndSettle();
    expect(find.text('0 of 6 complete'), findsOneWidget);
  });

  testWidgets('profile resets clean demo data', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete flight').first);
    await tester.pumpAndSettle();
    expect(find.text('Coastal sunset practice'), findsNothing);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Reset Demo Data'),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset Demo Data'));
    await tester.pumpAndSettle();

    expect(find.text('SkyLog'), findsOneWidget);

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();
    expect(find.text('Coastal sunset practice'), findsOneWidget);
    expect(find.text('Mountain overlook test'), findsOneWidget);
  });

  testWidgets('flight logs can be searched', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'mountain');
    await tester.pumpAndSettle();

    expect(find.text('Mountain overlook test'), findsOneWidget);
    expect(find.text('Coastal sunset practice'), findsNothing);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();

    expect(find.text('Coastal sunset practice'), findsOneWidget);
  });

  testWidgets('flight search shows no results state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'not-a-real-flight');
    await tester.pumpAndSettle();

    expect(find.text('No matching flights'), findsOneWidget);
  });

  testWidgets('adding a flight shows it in logs', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), 'Harbor orbit practice');
    await tester.enterText(fields.at(1), 'Qingdao harbor');
    await tester.enterText(fields.at(2), 'May 27, 2026');
    await tester.enterText(fields.at(3), '16 min');

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Flight'));
    await tester.pumpAndSettle();

    expect(find.text('Flight Logs'), findsOneWidget);
    expect(find.text('Harbor orbit practice'), findsOneWidget);
    expect(find.text('Qingdao harbor - May 27, 2026'), findsOneWidget);
  });

  testWidgets('add flight form resets after saving', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), 'Reset test flight');
    await tester.enterText(fields.at(1), 'Reset beach');
    await tester.enterText(fields.at(3), '9 min');

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Flight'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 600));
    await tester.pumpAndSettle();

    expect(find.text('Reset test flight'), findsNothing);
    final resetTitleField = tester.widget<EditableText>(
      find.byType(EditableText).first,
    );
    expect(resetTitleField.controller.text, 'New practice flight');
  });

  testWidgets('saved flights load from local storage', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'skylog_flights':
          '[{"title":"Saved beach flight","location":"Beach test field","date":"May 27, 2026","duration":"12 min","drone":"DJI Mini 4 Pro","weather":"Sunny","summary":"Loaded from local storage."}]',
    });

    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    expect(find.text('Saved beach flight'), findsOneWidget);
    expect(find.text('Beach test field - May 27, 2026'), findsOneWidget);
  });

  testWidgets('flight records can be deleted', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    expect(find.text('Coastal sunset practice'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete flight').first);
    await tester.pumpAndSettle();

    expect(find.text('Coastal sunset practice'), findsNothing);
    expect(find.text('Flight deleted.'), findsOneWidget);
  });

  testWidgets('flight log card opens detail screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Coastal sunset practice'));
    await tester.pumpAndSettle();

    expect(find.text('Flight Detail'), findsOneWidget);
    expect(find.text('Flight Data'), findsOneWidget);
    expect(find.text('Map Location'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Flight Summary'), findsOneWidget);
  });

  testWidgets('flight detail edits update the log list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Coastal sunset practice'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(EditableText).first,
      'Edited coast flight',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Edited coast flight'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Edited coast flight'), findsOneWidget);
    expect(find.text('Coastal sunset practice'), findsNothing);
  });

  testWidgets('add flight form requires title location and duration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), '');
    await tester.enterText(fields.at(1), '');
    await tester.enterText(fields.at(3), '');

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Flight'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, 600));
    await tester.pumpAndSettle();

    expect(find.text('Add a short title for this flight.'), findsOneWidget);
    expect(find.text('Location is required.'), findsOneWidget);
    expect(find.text('Flight duration is required.'), findsOneWidget);
  });

  testWidgets('v1 core workflow add search detail edit delete export', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    var fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), 'V1 checklist flight');
    await tester.enterText(fields.at(1), 'Checklist beach');
    await tester.enterText(fields.at(2), 'May 27, 2026');
    await tester.enterText(fields.at(3), '21 min');

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Flight'));
    await tester.pumpAndSettle();

    expect(find.text('V1 checklist flight'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'checklist');
    await tester.pumpAndSettle();
    expect(find.text('V1 checklist flight'), findsOneWidget);
    expect(find.text('Mountain overlook test'), findsNothing);

    await tester.tap(find.text('V1 checklist flight'));
    await tester.pumpAndSettle();
    expect(find.text('Flight Detail'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).first, 'V1 edited flight');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('V1 edited flight'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('V1 edited flight'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete flight').first);
    await tester.pumpAndSettle();
    expect(find.text('V1 edited flight'), findsNothing);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Export JSON Backup'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('export-json-button')));
    await tester.pumpAndSettle();
    expect(find.textContaining('JSON Backup'), findsWidgets);
  });
}
