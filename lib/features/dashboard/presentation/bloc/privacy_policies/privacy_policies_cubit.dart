import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_privacy_policies_usecase.dart';
import 'privacy_policies_state.dart';

class PrivacyPoliciesCubit extends Cubit<PrivacyPoliciesState> {
  PrivacyPoliciesCubit(this._getPrivacyPolicies)
      : super(const PrivacyPoliciesState());

  final GetPrivacyPoliciesUseCase _getPrivacyPolicies;

  Future<void> fetch({bool forceRefresh = false}) async {
    if (state.isLoading) return;
    if (state.hasData && !forceRefresh) {
      return;
    }

    emit(
      state.copyWith(
        status: PrivacyPoliciesStatus.loading,
        resetMessage: true,
      ),
    );

    final result = await _getPrivacyPolicies();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PrivacyPoliciesStatus.failure,
          message: failure.message,
        ),
      ),
      (policies) => emit(
        state.copyWith(
          status: PrivacyPoliciesStatus.success,
          policies: policies,
          resetMessage: true,
        ),
      ),
    );
  }
}
