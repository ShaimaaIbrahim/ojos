import 'package:json_annotation/json_annotation.dart';
import 'package:ojos_app/core/entities/notifications_entity.dart';
import 'package:ojos_app/core/models/base_model.dart';

part 'notifications_model.g.dart';

@JsonSerializable()
class NotificationsModel extends BaseModel<NotificationsEntity> {
  final String description;
  final String title;
  final String id;
  final int type;

  NotificationsModel(
      {required this.title,
      required this.description,
      required this.id,
      required this.type});

  //
  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsModelToJson(this);

  @override
  NotificationsEntity toEntity() => NotificationsEntity(
      description: this.description,
      title: this.title,
      id: this.id,
      type: this.type);
}
