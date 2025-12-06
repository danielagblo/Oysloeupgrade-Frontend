import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/dashboard_repository.dart';

class SubmitFeedbackUseCase extends UseCase<void, SubmitFeedbackParams> {
  SubmitFeedbackUseCase(this._repository);

  final DashboardRepository _repository;

  @override
  Future<Either<Failure, void>> call(SubmitFeedbackParams params) {
    return _repository.submitFeedback(
      rating: params.rating,
      message: params.message,
    );
  }
}

class SubmitFeedbackParams extends Equatable {
  const SubmitFeedbackParams({
    required this.rating,
    required this.message,
  });

  final int rating;
  final String message;

  @override
  List<Object?> get props => <Object?>[rating, message];
}
