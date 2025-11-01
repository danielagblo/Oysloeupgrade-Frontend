import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.pid,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.status,
    required this.image,
    required this.images,
    required this.productFeatures,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String pid;
  final String name;
  final String description;
  final String price;
  final String type;
  final String status;
  final String image;
  final List<String> images;
  final List<String> productFeatures;
  final int category;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => <Object?>[
        id,
        pid,
        name,
        description,
        price,
        type,
        status,
        image,
        images,
        productFeatures,
        category,
        createdAt,
        updatedAt,
      ];
}
