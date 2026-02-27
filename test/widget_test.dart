// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets('Weather app loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherApp());

    // Verify that the app title or some initial text is present.
    // Note: Since the app makes a network call immediately, and we aren't mocking it here,
    // we should just check for the static UI elements that are guaranteed to exist.
    // However, without mocking HTTP, the test might be flaky or fail if it tries to render network data.
    // For a simple smoke test, we'll just ensure it pumps without crashing.

    // Check for the "Обновить" button text which is part of the initial UI
    // (though it might say "Загрузка..." initially due to initState)
    // The button logic: _isLoading ? 'Загрузка...' : 'Обновить'
    // In initState, _isLoading is set to true immediately.

    expect(find.text('Загрузка...'), findsOneWidget);
  });
}
