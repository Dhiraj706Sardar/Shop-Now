import 'package:ecommerce_app/src/features/home/home_page.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class LoadProduct extends ProductEvent {
  final int id;

  const LoadProduct(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadCategories extends ProductEvent {
  const LoadCategories();
}

class LoadProductsByCategory extends ProductEvent {
  final String category;

  const LoadProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class SortProducts extends ProductEvent {
  final SortOrder order;
  final double price;

  const SortProducts(this.order, this.price);

  @override
  List<Object?> get props => [order, price];
}