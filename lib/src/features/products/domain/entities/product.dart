import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final Rating? rating;
  final double? discount;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.rating,
    this.discount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        description,
        category,
        imageUrl,
        rating,
        discount,
      ];
}

class Rating extends Equatable {
  final double rate;
  final int count;

  const Rating({
    required this.rate,
    required this.count,
  });

  @override
  List<Object> get props => [rate, count];
}
