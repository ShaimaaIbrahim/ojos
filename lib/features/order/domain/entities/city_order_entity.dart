import 'package:ojos_app/core/entities/base_entity.dart';

class CityOrderEntity extends BaseEntity {
  final int? id;
  final String? name;
  final String? shiping_time;
  final bool? status;

  CityOrderEntity({
    required this.id,
    required this.name,
    this.shiping_time,
    this.status,
  });

  @override
  List<Object> get props => [
        id ?? '',
        name ?? '',
        shiping_time ?? '',
        status ?? '',
      ];
}
