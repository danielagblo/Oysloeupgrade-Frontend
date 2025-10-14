import '../../domain/entities/otp_entity.dart';

class OtpResponseModel extends OtpResponseEntity {
  const OtpResponseModel({required super.message});

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}