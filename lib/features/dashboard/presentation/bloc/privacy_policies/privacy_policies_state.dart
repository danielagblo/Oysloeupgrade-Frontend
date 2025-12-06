import 'package:equatable/equatable.dart';

import '../../../domain/entities/privacy_policy_entity.dart';

enum PrivacyPoliciesStatus { initial, loading, success, failure }

class PrivacyPoliciesState extends Equatable {
  const PrivacyPoliciesState({
    this.status = PrivacyPoliciesStatus.initial,
    this.policies = const <PrivacyPolicyEntity>[],
    this.message,
  });

  final PrivacyPoliciesStatus status;
  final List<PrivacyPolicyEntity> policies;
  final String? message;

  bool get isLoading => status == PrivacyPoliciesStatus.loading;
  bool get hasError => status == PrivacyPoliciesStatus.failure;
  bool get hasData => policies.isNotEmpty;
  bool get isSuccess => status == PrivacyPoliciesStatus.success;

  PrivacyPoliciesState copyWith({
    PrivacyPoliciesStatus? status,
    List<PrivacyPolicyEntity>? policies,
    String? message,
    bool resetMessage = false,
  }) {
    return PrivacyPoliciesState(
      status: status ?? this.status,
      policies: policies ?? this.policies,
      message: resetMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, policies, message];
}
