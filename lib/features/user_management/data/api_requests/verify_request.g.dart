// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyRequest _$VerifyRequestFromJson(Map<String, dynamic> json) {
  return VerifyRequest(
    mobile: json['mobile'] as String?,
    code: json['otp_code'] as String?,
  );
}

Map<String, dynamic> _$VerifyRequestToJson(VerifyRequest instance) =>
    <String, dynamic>{
      'mobile': instance.mobile,
      'otp_code': instance.code,
    };
