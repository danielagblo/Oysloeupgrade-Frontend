import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/login_params.dart';
import '../../../../core/usecase/register_params.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
	Future<Either<Failure, AuthSessionEntity>> register(RegisterParams params);
	Future<Either<Failure, AuthSessionEntity>> login(LoginParams params);
	Future<Either<Failure, void>> logout();
	Future<AuthSessionEntity?> cachedSession();
}
