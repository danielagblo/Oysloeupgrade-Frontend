import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  const LocationEntity({
    required this.id,
    required this.name,
    this.region,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String? region;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get displayName {
    final String trimmedName = name.trim();
    final String trimmedRegion = region?.trim() ?? '';

    if (trimmedName.isNotEmpty) {
      return trimmedName;
    }

    if (trimmedRegion.isNotEmpty) {
      return trimmedRegion;
    }

    return 'Unknown location';
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        region,
        createdAt,
        updatedAt,
      ];
}
