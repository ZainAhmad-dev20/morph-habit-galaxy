import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:morph/main.dart';

void main() {
  testWidgets('Morph App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'morph_user_profile': '{"name":"Explorer","email":"test@morph.app","focusArea":"Mind","isRegistered":true}'
    });

    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MorphApp());
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    // Verify that our app title MORPH is present.
    expect(find.text('MORPH'), findsOneWidget);
  });
}
