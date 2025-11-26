import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/products/data/models/product_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/products')
  Future<List<ProductModel>> getProducts();

  @GET('/products/{id}')
  Future<ProductModel> getProduct(@Path('id') int id);

  @GET('/products/categories')
  Future<List<String>> getCategories();

  @GET('/products/category/{category}')
  Future<List<ProductModel>> getProductsByCategory(
      @Path('category') String category);
}
