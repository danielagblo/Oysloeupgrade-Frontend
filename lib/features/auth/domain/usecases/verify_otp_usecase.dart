import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/otp_params.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/otp_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<OtpResponseEntity, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, OtpResponseEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(params);
  }
}