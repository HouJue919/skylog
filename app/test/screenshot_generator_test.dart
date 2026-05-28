import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skylog/main.dart';

const _materialFontPath =
    '/Users/adanhou/Downloads/flutter/bin/cache/artifacts/material_fonts';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('generate portfolio screenshots', (tester) async {
    await tester.runAsync(_loadScreenshotFonts);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const SkyLogApp());
    await _pumpForScreenshot(tester);

    await expectLater(
      find.byType(SkyLogApp),
      matchesGoldenFile('../../portfolio/screenshots/01-home-dashboard.png'),
    );

    await tester.tap(find.text('Logs'));
    await _pumpForScreenshot(tester);
    await expectLater(
      find.byType(SkyLogApp),
      matchesGoldenFile('../../portfolio/screenshots/02-flight-logs.png'),
    );

    await tester.enterText(find.byType(TextField), 'mountain');
    await _pumpForScreenshot(tester);
    await expectLater(
      find.byType(SkyLogApp),
      matchesGoldenFile('../../portfolio/screenshots/03-search-results.png'),
    );

    await tester.tap(find.text('Add'));
    await _pumpForScreenshot(tester);
    await expectLater(
      find.byType(SkyLogApp),
      matchesGoldenFile('../../portfolio/screenshots/04-add-flight.png'),
    );

    await tester.tap(find.text('Logs'));
    await _pumpForScreenshot(tester);
    await tester.tap(find.byTooltip('Clear search'));
    await _pumpForScreenshot(tester);
    await tester.tap(find.text('Coastal sunset practice'));
    await _pumpForScreenshot(tester);
    await expectLater(
      find.byType(SkyLogApp),
      matchesGoldenFile('../../portfolio/screenshots/05-flight-detail.png'),
    );

    await tester.tap(find.byIcon(Icons.edit));
    await _pumpForScreenshot(tester);
    await expectLater(
      find.byType(SkyLogApp),
      matchesGoldenFile('../../portfolio/screenshots/06-edit-mode.png'),
    );

    await tester.pageBack();
    await _pumpForScreenshot(tester);
    await tester.pageBack();
    await _pumpForScreenshot(tester);
    await tester.tap(find.byIcon(Icons.person_outline));
    await _pumpForScreenshot(tester);
    await expectLater(
      find.byType(SkyLogApp),
      matchesGoldenFile('../../portfolio/screenshots/07-profile.png'),
    );
  }, skip: true);
}

Future<void> _loadScreenshotFonts() async {
  await _loadFont('Roboto', '$_materialFontPath/Roboto-Regular.ttf');
  await _loadFont(
    'MaterialIcons',
    '$_materialFontPath/MaterialIcons-Regular.otf',
  );
}

Future<void> _loadFont(String family, String path) async {
  final bytes = Uint8List.fromList(await File(path).readAsBytes());
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.sublistView(bytes)));

  await loader.load();
}

Future<void> _pumpForScreenshot(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
}
