import 'package:equatable/equatable.dart';

import '../../../domain/entities/terms_condition_entity.dart';

enum TermsConditionsStatus { initial, loading, success, failure }

class TermsConditionsState extends Equatable {
  const TermsConditionsState({
    this.status = TermsConditionsStatus.initial,
    this.terms = const <TermsConditionEntity>[],
    this.message,
  });

  final TermsConditionsStatus status;
  final List<TermsConditionEntity> terms;
  final String? message;

  bool get isLoading => status == TermsConditionsStatus.loading;
  bool get hasError => status == TermsConditionsStatus.failure;
  bool get hasData => terms.isNotEmpty;
  bool get isSuccess => status == TermsConditionsStatus.success;

  TermsConditionsState copyWith({
    TermsConditionsStatus? status,
    List<TermsConditionEntity>? terms,
    String? message,
    bool resetMessage = false,
  }) {
    return TermsConditionsState(
      status: status ?? this.status,
      terms: terms ?? this.terms,
      message: resetMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, terms, message];
}
