import 'package:flutter_test/flutter_test.dart';

import 'package:handa/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HandaApp());
    expect(find.text('හඬ'), findsWidgets);
  });
}
