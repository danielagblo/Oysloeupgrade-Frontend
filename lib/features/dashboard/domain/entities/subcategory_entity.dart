import 'package:equatable/equatable.dart';

class SubcategoryEntity extends Equatable {
  const SubcategoryEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
  });

  final int id;
  final int categoryId;
  final String name;
  final String? description;

  @override
  List<Object?> get props => <Object?>[id, categoryId, name, description];
}
