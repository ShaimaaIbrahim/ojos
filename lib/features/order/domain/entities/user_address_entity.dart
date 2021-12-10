import 'package:ojos_app/core/entities/base_entity.dart';

class UserAddressEntity extends BaseEntity {
  final int? id;
  final String? description;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool? is_default;
  final int? user_id;

  UserAddressEntity({
    required this.id,
    required this.user_id,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.description,
    required this.is_default,
  });

  @override
  List<Object> get props => [
        id ?? '',
        user_id ?? '',
        address ?? '',
        longitude ?? '',
        latitude ?? '',
        description ?? '',
        is_default ?? '',
      ];
}
