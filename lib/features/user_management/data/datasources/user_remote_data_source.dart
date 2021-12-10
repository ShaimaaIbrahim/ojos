import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ojos_app/core/datasources/remote_data_source.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/features/user_management/data/api_requests/forgot_password_request.dart';
import 'package:ojos_app/features/user_management/data/api_requests/login_request.dart';
import 'package:ojos_app/features/user_management/data/api_requests/register_request.dart';
import 'package:ojos_app/features/user_management/data/api_requests/reset_password_request.dart';
import 'package:ojos_app/features/user_management/data/api_requests/verify_request.dart';
import 'package:ojos_app/features/user_management/data/models/forget_result_model.dart';
import 'package:ojos_app/features/user_management/data/models/login_result_model.dart';
import 'package:ojos_app/features/user_management/data/models/register_result_model.dart';
import 'package:ojos_app/features/user_management/data/models/verify_result_model.dart';
import 'package:flutter/foundation.dart';

abstract class UserRemoteDataSource extends RemoteDataSource {
  Future<Either<BaseError, RegisterResultModel>> register({
    required RegisterRequest data,
    required CancelToken cancelToken,
  });

  Future<Either<BaseError, Object>> verify({
    required VerifyRequest data,
    required CancelToken cancelToken,
  });

  Future<Either<BaseError, Object>> reSendCode({
    required String username,
    required String device_token,
    required CancelToken cancelToken,
  });

  Future<Either<BaseError, LoginResultModel>> login({
    required LoginRequest data,
    required CancelToken cancelToken,
  });

  Future<Either<BaseError, Object>> forgetPassword({
    Map<String, dynamic>? queryParameters,
    required CancelToken cancelToken,
  });

  ///===========================================================================

  // Future<Either<BaseError, VerifyResultModel>> registerPhoneNumber({
  //   required Map<String, dynamic> data,
  // required  CancelToken cancelToken,
  // });

  Future<Either<BaseError, Object>> resendCode({
    required Map<String, dynamic>? queryParameters,
    required String urlResendCode,
    required CancelToken cancelToken,
  });

  Future<Either<BaseError, Object>> verifiedForgotPassword({
    Map<String, dynamic>? queryParameters,
    required CancelToken cancelToken,
  });

  Future<Either<BaseError, Object>> changePassword({
    Map<String, dynamic>? queryParameters,
    required CancelToken cancelToken,
  });

  Future<Either<BaseError, ForgetResultModel>> forgotPassword({
    required ForgotPasswordRequest data,
    required CancelToken cancelToken,
  });

  Future<Either<BaseError, Object>> resetPassword({
    required ResetPasswordRequest data,
    required CancelToken cancelToken,
  });

  Future<Either<BaseError, Object>> changeUserNamePhoneNumberOrEmail({
    Map<String, dynamic>? queryParameters,
    required String changeUserNameUrl,
    required CancelToken cancelToken,
  });
}
