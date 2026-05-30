import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skylog/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> saveFlight(WidgetTester tester) async {
    final saveButton = tester.widget<FilledButton>(
      find.byKey(const Key('save-flight-button')),
    );
    saveButton.onPressed?.call();
    await tester.pumpAndSettle();
  }

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

    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();
    expect(find.text('Flight Map'), findsOneWidget);
    expect(find.text('Mapped Flights'), findsOneWidget);
    expect(find.text('Qingdao coast'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('SkyLog v3.5'), findsOneWidget);
    expect(find.text('Local Draft Summary'), findsOneWidget);
  });

  testWidgets('profile switches navigation language to Chinese', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('中文'), findsOneWidget);

    await tester.tap(find.text('中文'));
    await tester.pumpAndSettle();

    expect(find.text('语言设置'), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('日志'), findsOneWidget);
    expect(find.text('添加'), findsOneWidget);
    expect(find.text('检查'), findsOneWidget);
    expect(find.text('地图'), findsOneWidget);
    expect(find.text('我的'), findsWidgets);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Local Draft Summary'), findsOneWidget);
  });

  testWidgets('map screen opens mapped flight detail', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();

    expect(find.text('Mapped Flights'), findsOneWidget);
    expect(
      find.text('36.0671, 120.3826 - Coastal sunset practice'),
      findsOneWidget,
    );

    await tester.tap(find.text('Qingdao coast'));
    await tester.pumpAndSettle();

    expect(find.text('Flight Detail'), findsOneWidget);
    expect(find.text('Coastal sunset practice'), findsOneWidget);
  });

  testWidgets('profile groups beta tools by audience', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Beta Testing'),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Beta Testing'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Project Info'),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Project Info'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Release Tools'),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Release Tools'), findsOneWidget);
  });

  testWidgets('profile shows flight and drone statistics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Pilot Stats'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Pilot Stats'), findsOneWidget);
    expect(find.text('Flight Time'), findsOneWidget);
    expect(find.text('1h 13m'), findsOneWidget);
    expect(find.text('Mapped'), findsOneWidget);
    expect(find.text('With Media'), findsOneWidget);
    expect(find.text('Primary Drone'), findsOneWidget);
    expect(find.text('DJI Mini 4 Pro'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('2 flights - 42m total'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('DJI Mini 4 Pro'), findsWidgets);
    expect(find.text('2 flights - 42m total'), findsOneWidget);
    expect(find.text('Latest: May 24, 2026'), findsOneWidget);
    expect(find.text('2 mapped'), findsOneWidget);
    expect(find.text('2 media'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('1 flight - 31m total'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('DJI Mini 3'), findsOneWidget);
    expect(find.text('1 flight - 31m total'), findsOneWidget);
  });

  testWidgets('profile explains beta status and local data privacy', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('about-beta-button')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final aboutBetaInkWell = tester.widget<InkWell>(
      find.descendant(
        of: find.byKey(const Key('about-beta-button')),
        matching: find.byType(InkWell),
      ),
    );
    aboutBetaInkWell.onTap?.call();
    await tester.pumpAndSettle();

    expect(find.text('About This Beta'), findsWidgets);
    expect(find.textContaining('student-built beta'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    final privacyInkWell = tester.widget<InkWell>(
      find.descendant(
        of: find.byKey(const Key('privacy-note-button')),
        matching: find.byType(InkWell),
      ),
    );
    privacyInkWell.onTap?.call();
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

  testWidgets('profile opens small beta feedback plan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('small-beta-feedback-plan-button')),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final feedbackPlanTopLeft = tester.getTopLeft(
      find.byKey(const Key('small-beta-feedback-plan-button')),
    );
    await tester.tapAt(feedbackPlanTopLeft + const Offset(120, 32));
    await tester.pumpAndSettle();

    expect(find.text('Small Beta Feedback Plan'), findsWidgets);
    expect(find.textContaining('Goal for v2.0'), findsOneWidget);
    expect(find.textContaining('2-3 regular users'), findsOneWidget);
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

  testWidgets('profile opens tester quick start', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('tester-quick-start-button')),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final quickStartTopLeft = tester.getTopLeft(
      find.byKey(const Key('tester-quick-start-button')),
    );
    await tester.tapAt(quickStartTopLeft + const Offset(120, 32));
    await tester.pumpAndSettle();

    expect(find.text('Tester Quick Start'), findsWidgets);
    expect(find.textContaining('60-second test'), findsOneWidget);
    expect(find.textContaining('Please use sample data only'), findsOneWidget);
  });

  testWidgets('profile opens web update tips', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('web-update-tips-button')),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final updateTipsTopLeft = tester.getTopLeft(
      find.byKey(const Key('web-update-tips-button')),
    );
    await tester.tapAt(updateTipsTopLeft + const Offset(120, 32));
    await tester.pumpAndSettle();

    expect(find.text('Web Update Tips'), findsWidgets);
    expect(find.textContaining('private/incognito window'), findsOneWidget);
    expect(find.textContaining('browsers may keep'), findsOneWidget);
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

  testWidgets('profile opens automatic web deploy plan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('automatic-web-deploy-button')),
      80,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final automaticDeployTopLeft = tester.getTopLeft(
      find.byKey(const Key('automatic-web-deploy-button')),
    );
    await tester.tapAt(automaticDeployTopLeft + const Offset(120, 32));
    await tester.pumpAndSettle();

    expect(find.text('Automatic Web Deploy'), findsWidgets);
    expect(find.textContaining('pushed to main'), findsOneWidget);
    expect(find.textContaining('GitHub Actions deploys'), findsOneWidget);
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

  testWidgets('profile shows backup report', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('3 records - 1h 13m total flight time'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('3 records - 1h 13m total flight time'), findsOneWidget);
    expect(
      find.text(
        '3 map-ready records and 3 media-linked records are included in exports.',
      ),
      findsOneWidget,
    );
    expect(find.text('JSON backup'), findsOneWidget);
    expect(find.text('CSV table'), findsOneWidget);
    expect(find.text('Local device'), findsOneWidget);
    expect(
      find.textContaining('Export before clearing browser data'),
      findsOneWidget,
    );
  });

  testWidgets('profile exports CSV table', (WidgetTester tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            return null;
          }
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    final exportCsvButton = find.byKey(const Key('export-csv-button'));
    await tester.scrollUntilVisible(
      exportCsvButton,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final exportCsvInkWell = tester.widget<InkWell>(
      find.descendant(of: exportCsvButton, matching: find.byType(InkWell)),
    );
    exportCsvInkWell.onTap?.call();
    await tester.pumpAndSettle();

    expect(find.textContaining('CSV Table'), findsWidgets);
    expect(find.text('CSV rows: 3'), findsOneWidget);
    expect(
      find.textContaining('Columns: Title, Location, Latitude'),
      findsOneWidget,
    );
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

    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Title')),
      'Checklist saved flight',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Location')),
      'Safety field',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Duration')),
      '14 min',
    );

    await tester.scrollUntilVisible(
      find.text('Save Flight'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await saveFlight(tester);

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

    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Title')),
      'Harbor orbit practice',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Location')),
      'Qingdao harbor',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Date')),
      'May 27, 2026',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Duration')),
      '16 min',
    );

    await tester.scrollUntilVisible(
      find.text('Save Flight'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await saveFlight(tester);

    expect(find.text('Flight Logs'), findsOneWidget);
    expect(find.text('Harbor orbit practice'), findsOneWidget);
    expect(find.text('Qingdao harbor - May 27, 2026'), findsOneWidget);
  });

  testWidgets('new flight saves creative review fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Title')),
      'Creative review flight',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Location')),
      'Practice field',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Duration')),
      '19 min',
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('flight-field-Purpose')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Purpose')),
      'Practice reveal shots.',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Issues')),
      'Yaw movement was too fast.',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Next Improvements')),
      'Use slower stick input next time.',
    );

    await tester.scrollUntilVisible(
      find.text('Save Flight'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await saveFlight(tester);

    expect(find.text('Flight Logs'), findsOneWidget);
    expect(find.text('Creative review flight'), findsOneWidget);
    expect(find.text('Practice reveal shots.'), findsOneWidget);

    await tester.tap(find.text('Creative review flight'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Creative Review'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Purpose'), findsOneWidget);
    expect(find.text('Practice reveal shots.'), findsOneWidget);
    expect(find.text('Issues'), findsOneWidget);
    expect(find.text('Yaw movement was too fast.'), findsOneWidget);
    expect(find.text('Next Improvements'), findsOneWidget);
    expect(find.text('Use slower stick input next time.'), findsOneWidget);
  });

  testWidgets('new flight saves map coordinates', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Title')),
      'Coordinate test flight',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Location')),
      'Map practice field',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Latitude')),
      '36.1234',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Longitude')),
      '120.5678',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Duration')),
      '12 min',
    );

    await tester.scrollUntilVisible(
      find.text('Save Flight'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await saveFlight(tester);

    await tester.tap(find.text('Coordinate test flight'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Map Location'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Map Location'), findsOneWidget);
    expect(find.text('Coordinates'), findsOneWidget);
    expect(find.text('36.1234, 120.5678'), findsWidgets);
  });

  testWidgets('new flight saves media metadata', (WidgetTester tester) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Title')),
      'Media test flight',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Location')),
      'Media beach',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Duration')),
      '15 min',
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('flight-field-Media Type')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Media Type')),
      'Video',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Media Path')),
      'media-beach-orbit.mp4',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Media Caption')),
      'Best orbit clip for editing later.',
    );

    await tester.scrollUntilVisible(
      find.text('Save Flight'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await saveFlight(tester);

    expect(find.text('Media test flight'), findsOneWidget);
    expect(find.text('Video - media-beach-orbit.mp4'), findsWidgets);

    await tester.tap(find.text('Media test flight'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Media'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Type'), findsOneWidget);
    expect(find.text('Video'), findsWidgets);
    expect(find.text('Path'), findsOneWidget);
    expect(find.text('media-beach-orbit.mp4'), findsOneWidget);
    expect(find.text('Caption'), findsOneWidget);
    expect(find.text('Best orbit clip for editing later.'), findsOneWidget);
  });

  testWidgets('add flight form resets after saving', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Title')),
      'Reset test flight',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Location')),
      'Reset beach',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Duration')),
      '9 min',
    );

    await tester.scrollUntilVisible(
      find.text('Save Flight'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await saveFlight(tester);

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 600));
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

    await tester.scrollUntilVisible(
      find.text('Map Location'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Map Location'), findsOneWidget);
    expect(find.text('36.0671, 120.3826'), findsWidgets);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Creative Review'), findsOneWidget);
  });

  testWidgets('flight detail previews AI prompt without API', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Coastal sunset practice'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('AI Readiness'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('AI Readiness'), findsOneWidget);
    expect(
      find.text('Prompt preview only. No network request or API key is used.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('ai-prompt-preview-button')));
    await tester.pumpAndSettle();

    expect(find.text('AI Prompt Preview'), findsOneWidget);
    expect(find.textContaining('No API call is made'), findsOneWidget);
    expect(
      find.textContaining('Flight title: Coastal sunset practice'),
      findsOneWidget,
    );
    expect(find.textContaining('Location: Qingdao coast'), findsOneWidget);
    expect(
      find.textContaining('Purpose: Practice smooth coastal tracking shots'),
      findsOneWidget,
    );
    expect(find.textContaining('Not sent in this preview'), findsOneWidget);
  });

  testWidgets('flight detail generates local draft summary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkyLogApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Coastal sunset practice'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('local-draft-summary-button')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('local-draft-summary-button')));
    await tester.pumpAndSettle();

    expect(find.text('Local Draft Summary'), findsOneWidget);
    expect(
      find.textContaining('Coastal sunset practice was a 24 min flight'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Review draft: Good low-altitude'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Issue to remember: Crosswind made the last orbit'),
      findsOneWidget,
    );
    expect(find.textContaining('not AI output'), findsOneWidget);
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

    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Title')),
      '',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Location')),
      '',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Duration')),
      '',
    );

    await tester.scrollUntilVisible(
      find.text('Save Flight'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await saveFlight(tester);

    await tester.scrollUntilVisible(
      find.text('Add a short title for this flight.'),
      180,
      scrollable: find.byType(Scrollable).first,
    );

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

    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Title')),
      'V1 checklist flight',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Location')),
      'Checklist beach',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Date')),
      'May 27, 2026',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('flight-field-Duration')),
      '21 min',
    );

    await tester.scrollUntilVisible(
      find.text('Save Flight'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await saveFlight(tester);

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
