import 'package:ojos_app/core/entities/base_entity.dart';

class ItemEntity extends BaseEntity {
  final int? id;
  final String? name;

  ItemEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [
        id ?? '',
        name ?? '',
      ];
}
