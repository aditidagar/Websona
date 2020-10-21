// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'package:websona/main.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  test('bottomnavigationbar test', () async {
    await driver.waitFor(find.byValueKey('bottom'));
    await driver.tap(find.text('My Codes'));
    print('clicked on first');
    await driver.tap(find.text('Contacts'));
    print('clicked on second too');
  });
}
