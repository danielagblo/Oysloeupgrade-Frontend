import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/terms_condition_entity.dart';

class TermsConditionModel extends TermsConditionEntity {
  const TermsConditionModel({
    required super.id,
    required super.title,
    required super.date,
    required super.body,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TermsConditionModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionModel(
      id: _parseId(json['id']),
      title: _parseString(json['title']) ?? '',
      date: DateUtilsExt.parseOrEpoch(json['date'] as String?),
      body: _parseString(json['body']) ?? '',
      createdAt: DateUtilsExt.parseOrEpoch(json['created_at'] as String?),
      updatedAt: DateUtilsExt.parseOrEpoch(json['updated_at'] as String?),
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    final String result = value.toString().trim();
    return result.isEmpty ? null : result;
  }
}
