import 'package:dio/dio.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/results/result.dart';
import 'package:ojos_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:ojos_app/features/cart/data/models/coupon_code_model.dart';
import 'package:ojos_app/features/cart/domin/entities/coupon_code_entity.dart';
import 'package:ojos_app/features/cart/domin/repositories/cartr_repository.dart';

class ConcreteCartRepository extends CartRepository {
  final CartRemoteDataSource remoteDataSource;

  ConcreteCartRepository(this.remoteDataSource);

  @override
  Future<Result<BaseError, CouponCodeEntity>> applyCouponCode({
    required String total,
    required String couponCode,
    required CancelToken cancelToken,
  }) async {
    final remoteResult = await remoteDataSource.applyCouponCode(
      total: total,
      couponCode: couponCode,
      cancelToken: cancelToken,
    );
    return execute<CouponCodeModel, CouponCodeEntity>(
        remoteResult: remoteResult);
  }
}
