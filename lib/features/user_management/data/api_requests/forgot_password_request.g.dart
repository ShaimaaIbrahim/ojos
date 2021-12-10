// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
    Map<String, dynamic> json) {
  return ForgotPasswordRequest(
    mobile: json['mobile'] as String?,
    device_token: json['device_token'] as String?,
  );
}

Map<String, dynamic> _$ForgotPasswordRequestToJson(
        ForgotPasswordRequest instance) =>
    <String, dynamic>{
      'mobile': instance.mobile,
      'device_token': instance.device_token,
    };
