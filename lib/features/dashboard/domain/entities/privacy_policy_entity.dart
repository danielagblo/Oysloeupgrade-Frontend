import 'package:equatable/equatable.dart';

class PrivacyPolicyEntity extends Equatable {
  const PrivacyPolicyEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final DateTime date;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        date,
        body,
        createdAt,
        updatedAt,
      ];
}
