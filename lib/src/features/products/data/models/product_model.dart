import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required int id,
    required String title,
    required num price,
    required String description,
    required String category,
    required String image,
    RatingModel? rating,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Product toEntity() {
    return Product(
      id: id,
      name: title,
      price: price.toDouble(),
      description: description,
      category: category,
      imageUrl: image,
      rating: rating?.toEntity(),
      discount: null, // Can be calculated or fetched separately
    );
  }
}

@freezed
class RatingModel with _$RatingModel {
  const RatingModel._();

  const factory RatingModel({
    required num rate,
    required int count,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  Rating toEntity() {
    return Rating(
      rate: rate.toDouble(),
      count: count,
    );
  }
}
