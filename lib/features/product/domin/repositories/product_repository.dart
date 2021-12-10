import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/core/repositories/repository.dart';
import 'package:ojos_app/core/results/result.dart';
import 'package:ojos_app/features/product/domin/entities/product_details_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_favorite_entity.dart';

abstract class ProductRepository extends Repository {
  Future<Result<BaseError, List<ProductEntity>>> getProducts({
    int? pagesize,
    int? page,
    Map<String, dynamic>? filterParams,
    bool? isFromSearchPage,
    required CancelToken cancelToken,
  });

  Future<Result<BaseError, List<ProductEntity>>> getTestResult({
    Map<dynamic, dynamic>? filterParams,
    required CancelToken cancelToken,
  });

  Future<Result<BaseError, List<ProductEntity>>> getMyProductsResult({
    Map<String, String>? filterParams,
    required CancelToken cancelToken,
  });

  Future<Result<BaseError, ProductDetailsEntity>> getProductDetails({
    required int id,
    required CancelToken cancelToken,
  });

  Future<Result<BaseError, List<ProductFavoriteEntity>>> fetchFavoriteProducts({
    int? pagesize,
    int? page,
    Map<String, String>? filterParams,
    required CancelToken cancelToken,
  });

  Future<Result<BaseError, Object>> addOrRemoveFavorite({
    required int productID,
    required CancelToken cancelToken,
  });

  Future<Result<BaseError, Object>> addReview({
    required int productID,
    required String review,
    required double rate,
    required CancelToken cancelToken,
  });
}
