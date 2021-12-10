import 'package:ojos_app/core/entities/base_entity.dart';

class NotificationsEntity extends BaseEntity {
  final String? description;
  final String? id;
  final String? title;
  final int? type;

  NotificationsEntity(
      {required this.description,
      required this.title,
      required this.id,
      required this.type});

  @override
  List<Object> get props => [
        description ?? '',
        title ?? '',
        type ?? '',
        id ?? '',
      ];
}
