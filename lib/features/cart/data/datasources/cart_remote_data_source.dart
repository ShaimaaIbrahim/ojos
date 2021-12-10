import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ojos_app/core/datasources/remote_data_source.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/features/cart/data/models/coupon_code_model.dart';

abstract class CartRemoteDataSource extends RemoteDataSource {
  Future<Either<BaseError, CouponCodeModel>> applyCouponCode({
    required String total,
    required String couponCode,
    required CancelToken cancelToken,
  });
}
