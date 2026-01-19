import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/product_model.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/get_products.dart';
import 'product_event.dart';
import 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {

  ProductBloc(
    this._getProducts,
    this._getProduct,
    this._getCategories,
  ) : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProduct>(_onLoadProduct);
    on<LoadCategories>(_onLoadCategories);
    on<SearchProducts>(_onSearchProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<SortProducts>(_onSortProducts);
  }
  final GetProducts _getProducts;
  final GetProduct _getProduct;
  final GetCategories _getCategories;

  List<ProductModel> _allProducts = [];
  List<String> _categories = [];

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    final result = await _getProducts(NoParams());

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        _allProducts = products;
        emit(ProductsLoaded(products, _categories));
      },
    );
  }

  Future<void> _onLoadProduct(
    LoadProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    final result = await _getProduct(GetProductParams(id: event.id));

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) => emit(ProductLoaded(product)),
    );
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    // Don't emit loading state to avoid conflicts
    final result = await _getCategories(NoParams());

    result.fold(
      (failure) {
        // Keep current state, just log error
        print('Failed to load categories: ${failure.message}');
      },
      (categories) {
        _categories = categories;
        // Emit combined state with current products
        if (state is ProductsLoaded) {
          emit(ProductsLoaded(_allProducts, categories));
        } else {
          emit(ProductsLoaded(_allProducts, categories));
        }
      },
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
      emit(ProductsLoaded(_allProducts, _categories));
      return;
    }

    final filtered = _allProducts.where((product) {
      final nameMatch = product.title.toLowerCase().contains(query);
      final descMatch = product.description.toLowerCase().contains(query);
      final categoryMatch = product.category.toLowerCase().contains(query);
      return nameMatch || descMatch || categoryMatch;
    }).toList();

    emit(ProductsLoaded(filtered, _categories));
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    if (event.category == 'All') {
      emit(ProductsLoaded(_allProducts, _categories));
      return;
    }

    final filtered = _allProducts
        .where((product) => product.category == event.category)
        .toList();

    emit(ProductsLoaded(filtered, _categories));
  }

  Future<void> _onSortProducts(
    SortProducts event,
    Emitter<ProductState> emit,
  ) async {
    final sorted = _allProducts
        .where((product) => product.price > event.price)
        .toList();

    emit(ProductsLoaded(sorted, _categories));
  }
}
