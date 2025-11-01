import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String email;
  final String phone;
  final String name;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? address;
  final String? avatar;
  final bool? deleted;
  final String? level;
  final int? referralPoints;
  final String? referralCode;
  final bool? isActive;
  final bool? isStaff;
  final bool? isSuperuser;
  final bool? createdFromApp;
  final bool? phoneVerified;
  final bool? emailVerified;
  final String? preferredNotificationEmail;
  final String? preferredNotificationPhone;
  final bool? adminVerified;

  const AuthUserEntity({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.avatar,
    this.deleted,
    this.level,
    this.referralPoints,
    this.referralCode,
    this.isActive,
    this.isStaff,
    this.isSuperuser,
    this.createdFromApp,
    this.phoneVerified,
    this.emailVerified,
    this.preferredNotificationEmail,
    this.preferredNotificationPhone,
    this.adminVerified,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        name,
        lastLogin,
        createdAt,
        updatedAt,
        address,
        avatar,
        deleted,
        level,
        referralPoints,
        referralCode,
        isActive,
        isStaff,
        isSuperuser,
        createdFromApp,
        phoneVerified,
        emailVerified,
        preferredNotificationEmail,
        preferredNotificationPhone,
        adminVerified,
      ];
}

class AuthSessionEntity extends Equatable {
  final AuthUserEntity user;
  final String token;

  const AuthSessionEntity({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}