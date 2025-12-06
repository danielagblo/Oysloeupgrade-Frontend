import 'package:equatable/equatable.dart';

import '../../../domain/entities/subcategory_entity.dart';

enum SubcategoriesStatus { initial, loading, success, failure }

class SubcategoriesState extends Equatable {
  const SubcategoriesState({
    this.status = SubcategoriesStatus.initial,
    this.cache = const <int, List<SubcategoryEntity>>{},
    this.loadingCategoryId,
    this.message,
  });

  final SubcategoriesStatus status;
  final Map<int, List<SubcategoryEntity>> cache;
  final int? loadingCategoryId;
  final String? message;

  bool get isLoading => status == SubcategoriesStatus.loading;
  bool get hasError => status == SubcategoriesStatus.failure;

  List<SubcategoryEntity> subcategoriesOf(int categoryId) {
    return cache[categoryId] ?? const <SubcategoryEntity>[];
  }

  SubcategoriesState copyWith({
    SubcategoriesStatus? status,
    Map<int, List<SubcategoryEntity>>? cache,
    int? loadingCategoryId,
    String? message,
    bool resetMessage = false,
  }) {
    return SubcategoriesState(
      status: status ?? this.status,
      cache: cache ?? this.cache,
      loadingCategoryId: loadingCategoryId,
      message: resetMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        cache,
        loadingCategoryId,
        message,
      ];
}
