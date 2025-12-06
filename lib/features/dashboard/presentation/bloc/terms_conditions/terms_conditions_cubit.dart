import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_terms_conditions_usecase.dart';
import 'terms_conditions_state.dart';

class TermsConditionsCubit extends Cubit<TermsConditionsState> {
  TermsConditionsCubit(this._getTermsConditions)
      : super(const TermsConditionsState());

  final GetTermsConditionsUseCase _getTermsConditions;

  Future<void> fetch({bool forceRefresh = false}) async {
    if (state.isLoading) return;
    if (state.hasData && !forceRefresh) {
      return;
    }

    emit(
      state.copyWith(
        status: TermsConditionsStatus.loading,
        resetMessage: true,
      ),
    );

    final result = await _getTermsConditions();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TermsConditionsStatus.failure,
          message: failure.message,
        ),
      ),
      (terms) => emit(
        state.copyWith(
          status: TermsConditionsStatus.success,
          terms: terms,
          resetMessage: true,
        ),
      ),
    );
  }
}
