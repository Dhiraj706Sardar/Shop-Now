import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/product_model.dart';
import '../repositories/product_repository.dart';

@lazySingleton
class GetProduct implements UseCase<ProductModel, GetProductParams> {
  final ProductRepository _repository;

  GetProduct(this._repository);

  @override
  Future<Either<Failure, ProductModel>> call(GetProductParams params) async {
    return await _repository.getProduct(params.id);
  }
}

class GetProductParams extends Equatable {
  final int id;

  const GetProductParams({required this.id});

  @override
  List<Object?> get props => [id];
}
