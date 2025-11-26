import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, ProductModel>> getProduct(int id);
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(
      String category);
}
