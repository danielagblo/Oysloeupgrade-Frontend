import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/subcategory_entity.dart';
import '../../../domain/usecases/get_subcategories_usecase.dart';
import 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  SubcategoriesCubit(this._getSubcategories)
      : super(const SubcategoriesState());

  final GetSubcategoriesUseCase _getSubcategories;

  Future<List<SubcategoryEntity>> fetchForCategory(int categoryId) async {
    if (state.cache.containsKey(categoryId) &&
        state.cache[categoryId]!.isNotEmpty) {
      return state.cache[categoryId]!;
    }

    if (state.isLoading && state.loadingCategoryId == categoryId) {
      return state.subcategoriesOf(categoryId);
    }

    emit(
      state.copyWith(
        status: SubcategoriesStatus.loading,
        loadingCategoryId: categoryId,
        resetMessage: true,
      ),
    );

    final result = await _getSubcategories(categoryId: categoryId);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: SubcategoriesStatus.failure,
            loadingCategoryId: null,
            message: failure.message,
          ),
        );
        return const <SubcategoryEntity>[];
      },
      (subcategories) {
        final Map<int, List<SubcategoryEntity>> updated =
            Map<int, List<SubcategoryEntity>>.from(state.cache);
        updated[categoryId] = subcategories;
        emit(
          state.copyWith(
            status: SubcategoriesStatus.success,
            cache: updated,
            loadingCategoryId: null,
            resetMessage: true,
          ),
        );
        return subcategories;
      },
    );
  }

  Future<void> prefetchForCategories(Iterable<int> categoryIds) async {
    for (final int id in categoryIds) {
      if (state.cache.containsKey(id)) continue;
      await fetchForCategory(id);
    }
  }
}
