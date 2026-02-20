import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:post_it/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PostItApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text('PostIt'), findsOneWidget);
  });
}
