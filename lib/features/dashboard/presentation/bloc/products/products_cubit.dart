import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._getProducts) : super(const ProductsState());

  final GetProductsUseCase _getProducts;

  Future<void> fetch({
    String? search,
    String? ordering,
  }) async {
    emit(
      state.copyWith(
        status: ProductsStatus.loading,
        resetMessage: true,
      ),
    );

    final result = await _getProducts(
      GetProductsParams(search: search, ordering: ordering),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductsStatus.failure,
          products: const <ProductEntity>[],
          message: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: ProductsStatus.success,
          products: products,
          resetMessage: true,
        ),
      ),
    );
  }
}
