import 'package:flutter_test/flutter_test.dart';
import 'package:pokedesk/main.dart';

void main() {
  testWidgets('PokéDesk app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PokeDeskApp());
    expect(find.byType(PokeDeskApp), findsOneWidget);
  });
}
