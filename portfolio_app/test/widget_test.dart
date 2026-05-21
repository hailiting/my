import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/app.dart';

void main() {
  testWidgets('App loads', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));
    expect(find.textContaining('海立婷'), findsWidgets);
  });
}
