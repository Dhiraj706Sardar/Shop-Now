import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/product_model.dart';
import '../repositories/product_repository.dart';

@lazySingleton
class GetProducts implements UseCase<List<ProductModel>, NoParams> {
  final ProductRepository _repository;

  GetProducts(this._repository);

  @override
  Future<Either<Failure, List<ProductModel>>> call(NoParams params) async {
    return await _repository.getProducts();
  }
}
