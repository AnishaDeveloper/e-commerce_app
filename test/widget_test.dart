import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/main.dart';

void main() {
  testWidgets('NOVA Store smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FakeStoreApp());
  });
}
