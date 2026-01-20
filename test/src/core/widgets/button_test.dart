import 'package:ecommerce_app/src/core/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PrimaryButton calls onPressed when tapped',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PrimaryButton(
          text: 'Buy Now',
          onPressed: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.text('Buy Now'));
    await tester.pump();

    expect(tapped, true);
  });

  testWidgets('PrimaryButton shows loader when isLoading is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PrimaryButton(
          text: 'Buy Now',
          isLoading: true,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Buy Now'), findsNothing);
  });

  testWidgets('PrimaryButton is disabled when loading',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PrimaryButton(
          text: 'Buy Now',
          isLoading: true,
          onPressed: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(tapped, false);
  });
}
