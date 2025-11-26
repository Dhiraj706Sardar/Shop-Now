import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

@lazySingleton
class GetCategories implements UseCase<List<String>, NoParams> {
  final ProductRepository _repository;

  GetCategories(this._repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await _repository.getCategories();
  }
}
