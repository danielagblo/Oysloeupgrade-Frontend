import 'package:equatable/equatable.dart';

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String email;
  final String newPassword;
  final String confirmPassword;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };

  @override
  List<Object?> get props => <Object?>[email, newPassword, confirmPassword];
}
