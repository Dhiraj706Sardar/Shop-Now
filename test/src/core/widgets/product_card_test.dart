import 'package:ecommerce_app/src/core/widgets/product_card.dart';
import 'package:ecommerce_app/src/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// mock Callback
class MockCallback extends Mock {
  void call();
}

void main() {
  const testProduct = Product(
    id: 1,
    name: 'Test',
    price: 100.0,
    description: 'Test description',
    category: 'Test category',
    imageUrl: 'https://via.placeholder.com/150',
    rating: Rating(rate: 4.5, count: 100),
  );

  late MockCallback onTap;
  late MockCallback onAddToCart;
  late MockCallback ontToggleFavorite;

  setUp(() {
    onTap = MockCallback();
    onAddToCart = MockCallback();
    ontToggleFavorite = MockCallback();
  });

  Widget createWidget({bool isFavorite = false}) {
    return MaterialApp(
      home: Scaffold(
        body: ProductCard(
          product: testProduct,
          isFavorite: isFavorite,
          onTap: onTap.call,
          onAddToCart: onAddToCart.call,
          onToggleFavorite: ontToggleFavorite.call,
        ),
      ),
    );
  }

  testWidgets('ProductCard should display product information', (tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pump();
    expect(find.text(testProduct.name), findsOneWidget);
    expect(
        find.text('\$${testProduct.price.toStringAsFixed(2)}'), findsOneWidget);
    expect(find.text(testProduct.category), findsOneWidget);
  });

  testWidgets('ProductCard should display favorite button', (tester) async {
    await tester.pumpWidget(createWidget(isFavorite: true));
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('ProductCard should display add to cart button', (tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pump();
    expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
  });
}
