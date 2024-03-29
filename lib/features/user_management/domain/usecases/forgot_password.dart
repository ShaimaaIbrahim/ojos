import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/params/base_params.dart';
import 'package:ojos_app/core/results/result.dart';
import 'package:ojos_app/core/usecases/usecase.dart';
import 'package:ojos_app/features/user_management/data/api_requests/forgot_password_request.dart';
import 'package:ojos_app/features/user_management/domain/entities/forget_result.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';

class ForgotPasswordParams extends BaseParams {
  final ForgotPasswordRequest data;

  ForgotPasswordParams({
    required this.data,
    required CancelToken cancelToken,
  }) : super(cancelToken: cancelToken);
}

class ForgotPassword extends UseCase<ForgetResult, ForgotPasswordParams> {
  final UserRepository repository;

  ForgotPassword(this.repository);

  @override
  Future<Result<BaseError, ForgetResult>> call(ForgotPasswordParams params) =>
      repository.forgotPassword(
        data: params.data,
        cancelToken: params.cancelToken,
      );
}
