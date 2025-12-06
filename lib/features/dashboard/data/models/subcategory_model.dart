import '../../domain/entities/subcategory_entity.dart';

class SubcategoryModel extends SubcategoryEntity {
  const SubcategoryModel({
    required super.id,
    required super.categoryId,
    required super.name,
    super.description,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'] as int? ?? 0,
      categoryId: json['category'] as int? ?? 0,
      name: _resolveString(json['name']) ?? '',
      description: _resolveString(json['description']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'category': categoryId,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  static String? _resolveString(dynamic value) {
    if (value == null) return null;
    final String resolved = value.toString().trim();
    return resolved.isEmpty ? null : resolved;
  }
}
