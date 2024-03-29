import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/results/result.dart';
import 'package:ojos_app/features/user_management/data/api_requests/forgot_password_request.dart';
import 'package:ojos_app/features/user_management/data/api_requests/login_request.dart';
import 'package:ojos_app/features/user_management/data/api_requests/register_request.dart';
import 'package:ojos_app/features/user_management/data/api_requests/reset_password_request.dart';
import 'package:ojos_app/features/user_management/data/api_requests/verify_request.dart';
import 'package:ojos_app/features/user_management/data/datasources/user_remote_data_source.dart';
import 'package:ojos_app/features/user_management/data/models/forget_result_model.dart';
import 'package:ojos_app/features/user_management/data/models/login_result_model.dart';
import 'package:ojos_app/features/user_management/data/models/register_result_model.dart';
import 'package:ojos_app/features/user_management/data/models/verify_result_model.dart';
import 'package:ojos_app/features/user_management/domain/entities/forget_result.dart';
import 'package:ojos_app/features/user_management/domain/entities/login_result.dart';
import 'package:ojos_app/features/user_management/domain/entities/register_result.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';

class ConcreteUserRepository extends UserRepository {
  final UserRemoteDataSource remoteDataSource;

  ConcreteUserRepository(this.remoteDataSource) : super();

  @override
  Future<Result<BaseError, RegisterResult>> register({
    required RegisterRequest data,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.register(
      data: data,
      cancelToken: cancelToken,
    );
    return execute<RegisterResultModel, RegisterResult>(
        remoteResult: remoteResult);
    // final remoteResult = await remoteDataSource.register(
    //   data: data,
    //   cancelToken: cancelToken,
    // );
    //
    // if (remoteResult.isLeft()) {
    // } else {
    //   final data = (remoteResult as Right<BaseError, LoginResultModel>).value;
    //   if (data != null && data.token != null && data.token.isNotEmpty) {
    //     await persistToken(data.token);
    //   }
    // }
    //
    // return execute<LoginResultModel, LoginResult>(
    //   remoteResult: remoteResult,
    // );
  }

  // @override
  // Future<Result<BaseError, LoginResult>> registerPhoneNumber({
  //   Map<String, dynamic> data,
  // required  CancelToken cancelToken,
  // }) async {
  //   final remoteResult = await remoteDataSource.registerPhoneNumber(
  //     data: data,
  //     cancelToken: cancelToken,
  //   );
  //
  //   return execute<VerifyResultModel, LoginResult>(
  //     remoteResult: remoteResult,
  //   );
  // }

  @override
  Future<Result<BaseError, Object>> resendCode({
    required Map<String, dynamic> queryParameters,
    required String urlResendCode,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.resendCode(
      queryParameters: queryParameters,
      urlResendCode: urlResendCode,
      cancelToken: cancelToken,
    );

    return executeForNoData(
      remoteResult: remoteResult,
    );
  }

  @override
  Future<Result<BaseError, Object>> verify({
    required VerifyRequest data,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.verify(
      data: data,
      cancelToken: cancelToken,
    ); // Persist token and profile if exists.

    return executeForNoData(
      remoteResult: remoteResult,
    );
  }

  @override
  Future<Result<BaseError, LoginResult>> login({
    required LoginRequest data,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.login(
      data: data,
      cancelToken: cancelToken,
    );
    // Persist token and profile if exists.
    if (remoteResult.isRight()) {
      final data = (remoteResult as Right<BaseError, LoginResultModel>).value;
      if (data != null &&
          data.accessToken != null &&
          data.accessToken!.isNotEmpty) {
        await persistToken(data.accessToken!);
        print('token is ===================${data.accessToken}');
        await UserRepository.persistUserDataLogin(data);
      }
    }

    return execute<LoginResultModel, LoginResult>(
      remoteResult: remoteResult,
    );
  }

  @override
  Future<Result<BaseError, Object>> forgetPassword({
    Map<String, dynamic>? queryParameters,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.forgetPassword(
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );

    return executeForNoData(
      remoteResult: remoteResult,
    );
  }

  @override
  Future<Result<BaseError, Object>> verifiedForgotPassword({
    Map<String, dynamic>? queryParameters,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.verifiedForgotPassword(
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );

    return executeForNoData(
      remoteResult: remoteResult,
    );
  }

  ///****

  @override
  Future<Result<BaseError, Object>> reSendCode({
    required String username,
    required String device_token,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.reSendCode(
      username: username,
      device_token: device_token,
      cancelToken: cancelToken,
    );
    return executeForNoData(remoteResult: remoteResult);
  }

  @override
  Future<Result<BaseError, ForgetResult>> forgotPassword({
    required ForgotPasswordRequest data,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.forgotPassword(
      data: data,
      cancelToken: cancelToken,
    );
    return execute<ForgetResultModel, ForgetResult>(remoteResult: remoteResult);
  }

  @override
  Future<Result<BaseError, Object>> resetPassword({
    required ResetPasswordRequest data,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.resetPassword(
      data: data,
      cancelToken: cancelToken,
    );
    return executeForNoData(remoteResult: remoteResult);
  }

  @override
  Future<Result<BaseError, Object>> changeUserNamePhoneNumberOrEmail({
    required Map<String, dynamic> queryParameters,
    required String changeUserNameUrl,
    required CancelToken cancelToken,
  }) async {
    final remoteResult =
        await remoteDataSource.changeUserNamePhoneNumberOrEmail(
      queryParameters: queryParameters,
      changeUserNameUrl: changeUserNameUrl,
      cancelToken: cancelToken,
    );
    return executeForNoData(remoteResult: remoteResult);
  }

  @override
  Future<Result<BaseError, Object>> changePassword({
    required Map<String, dynamic> queryParameters,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.changePassword(
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
    return executeForNoData(remoteResult: remoteResult);
  }
}
